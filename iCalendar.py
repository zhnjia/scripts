import sys
import csv
import calendar
from datetime import datetime, date
from icalendar import Calendar, Event, vDatetime

COL_NAME = 0
COL_DAY_OF_MONTH = 2

def generateICS(name, month, duties):
    td = date.today()
    cal = Calendar()
    cal['dtstart'] = datetime(td.year, month, 1)
    day = 1
    for duty in duties:
        et = Event()
        et['dtstart'] = vDatetime(datetime(td.year, month, day, 7, 30))
        et['dtend'] = vDatetime(datetime(td.year, month, day, 23, 59, 59))
        et['summary'] = duty
        cal.add_component(et)
        day += 1
    with open('./' + name + ".ics", 'w') as ics:
        ics.write(str(cal.to_ical(), encoding='utf-8').replace('\r\n', '\n').strip())

if len(sys.argv) == 2:
    with open(sys.argv[1], 'r', encoding='utf-8') as csv_f:
        duty_roster = csv.reader(csv_f)
        month = int(str(duty_roster.__next__()[0]).rstrip('月排班'))
        duty_roster.__next__()
        duty_roster.__next__()
        duty_roster.__next__()
        for row in duty_roster:
            name = row[COL_NAME]
            col_last = COL_DAY_OF_MONTH + calendar.monthrange(date.today().year, month)[1]
            generateICS(name, month, row[COL_DAY_OF_MONTH : col_last])
