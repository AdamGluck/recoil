import csv
import json
import httplib
import re
import os
from datetime import datetime, date, time
from flask import Flask
from geopy import geocoders

app = Flask(__name__)
CRIME_DATA_URL = "https://spreadsheets.google.com/pub?key=0Ak3IIavLYTovdHYxbDItQ255eWh1NzBiQXp5cmxRdmc&output=csv"

@app.route('/')
def run():
    ''' Returns all casualties from RedEye google doc file. 
    All this key-name finagling is because Parse doesn't accept spaces
    in its data type names, and it suggests a camelCase style.

    The google doc file doesn't supply a unique ID for each casualty, and often times
    data is incomplete (including the name of the victim). So, I'm making the assumption
    that the data is being added in order. 
    '''
    with open(CRIME_DATA_URL, 'rb') as f:
        reader = csv.DictReader(f)
        counter = 0
        for r in reader:
            counter += 1

            casualty = {}
            casualty["address"] = r["Address"]
            casualty["age"] = get_age(r["Age"])
            casualty["cause"] = r["Cause"]
            casualty["chargesTrialsUrl"] = r["Charges and trials"]
            casualty["dateTime"] = get_datetime(r["Date"], r["Time"])
            casualty["gdocRowNum"] = counter
            casualty["gender"] = r["Gender"]
            casualty["latitude"], casualty["longitude"] = get_latlong(r["Address"])
            casualty["locationType"] = r["Location"]
            casualty["name"] = r["Name"]
            casualty["neighborhood"] = r['Neighborhood']
            casualty["race"] = r["Race"]
            casualty["rdNumber"] = r["RD Number"]
            casualty["storyUrl"] = r["Story url"]
            post_to_parse(casualty)


def post_to_parse(casualty):
    connection = httplib.HTTPSConnection('api.parse.com', 443)
    connection.connect()
    connection.request('POST', '/1/classes/Casualty', json.dumps({
        "address": casualty["address"],
        "age": casualty["age"],
        "cause": casualty["cause"],
        "chargesTrialsUrl": casualty["chargesTrialsUrl"],
        "dateTime": {
            "__type": "Date",
            "iso": casualty["dateTime"]
        },
        "gender": casualty["gender"],
        "location": {
            "__type": "GeoPoint",
            "latitude": casualty["latitude"],
            "longitude": casualty["longitude"]
        },
        "locationType": casualty["locationType"],
        "name": casualty["name"],
        "neighborhood": casualty["neighborhood"],
        "race": casualty["race"],
        "rdNumber": casualty["rdNumber"],
        "storyUrl": casualty["storyUrl"]
    }), {
           "X-Parse-Application-Id": "BErxVzz4caaIQP3nGgGIHGRqfNbRcSGqlQAAUqN7",
           "X-Parse-REST-API-Key": "nTK5t1rUQceXaex9JK0XqgpEhZNU01pqJ9yq4Z58",
           "Content-Type": "application/json"
    })

    result = json.loads(connection.getresponse().read())
    print result

def 

def get_age(age):
    try:
        return int(age)

    # This occurs when a baby dies, literally :(
    # Need to extract age from '6 months'
    # Will present age in fraction
    except ValueError:
        m = re.match('(\d+) months', age)
        if m:
            month = float(m.group(1))
            return month / 12
        else:
            return 0


def get_datetime(my_date, my_time):
    ''' Takes a date in m/d/yyyy format, and a time in h:mm t.t. format,
    and returns an datetime in ISO 8601 format
    '''
    date_obj = None
    time_obj = None
    if my_date:
        date_match = re.match(r'(\d+)/(\d+)/(\d+)', my_date)
        month = int(date_match.group(1))
        day = int(date_match.group(2))
        year = int(date_match.group(3))
        date_obj = date(year, month, day)

    if my_time:
        # Parsing times structured h:mm t.t. or h t.t.
        # Definitely a better way to do this!! Should combine into 1 regex
        time_match = re.match(r'(\d+)\:(\d+) ([ap])\.m', my_time)
        time_match2 = re.match(r'^(\d+) ([ap])', my_time)
        if time_match:
            hour_int = int(time_match.group(1))
            a_or_p = time_match.group(3)
            hour = get_hour(hour_int, a_or_p == 'a')
            minute = int(time_match.group(2))
            time_obj = time(hour, minute)
        elif time_match2:
            hour_int = int(time_match2.group(1))
            a_or_p = time_match2.group(2)
            hour = get_hour(hour_int, a_or_p == 'a')
            time_obj = time(hour)
    
    if not time_obj:
        time_obj = time(0, 0, 0)

    print time_obj
    return datetime.combine(date_obj, time_obj).isoformat()

def get_hour(hour_int, is_am):
    if is_am:
        return hour_int
    else:
        return (hour_int + 12) % 24


def get_latlong(address):
    '''Takes an address and geocodes it using GoogleV3 geocoder'''
    g = geocoders.GeocoderDotUS(format_string="%s, Chicago, IL")
    try:
        place, (lat, lng) = g.geocode(address)
        return (lat, lng)
    except TypeError: # If address can't be geocoded
        return '', ''

