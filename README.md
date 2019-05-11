## Human-Resources-Management-System-in-COBOL-and-Fortran
# CSCI3180 – Principles of Programming Languages – Spring 2019

Assignment 1 — Human Resources Management System in FORTRAN and COBOL

# 1 Introduction

In this assignment, you have to implement a system for processing employee attendance records.
You are required to implement it once using FORTRAN and once using COBOL.

# 2 Assignment Details

## 2.1 Company Attendance Record Processing

Jimmy is designing a simple Human Resources Management System (the “System” hereafter) for
the PPL corporation. He is asking you to implement the attendance tracking module of this system,
which reads the employees’ daily attendance records, updates the monthly attendance records, and
generates a daily attendance summary for the human resources manager.

The PPL corporation’s employees have to work from 10:00am to 5:00pm. Employees have to tap
their smart staff card at the attendance reader when they arrive at work and depart after work
respectively. They will be fined for being late for each 15-minute period in whole. For example,
an employee will be fined for being 15 minutes late if he or she comes at 10:27am. On the other
hand, the PPL corporation provides overtime work compensation. Every month, employees can
claim at most 30 overtime working hours with proven attendance records. Only complete hours
of overtime work are counted. For example, if an employee leaves work at 6:47pm, he or she can
claim one hour of overtime work for that day.

The System keeps the employee data in a file:employees.txt. This file contains personal infor-
mation of all employees. Each line of the file is an employee record, containing the staff number,
name, gender, date of birth, hiring date, department and monthly salary of the employee. Also,
the System keeps an employee monthly attendance summary: monthly-attendance.txt. This
file contains the monthly attendance status of all employees. The first line of this file contains the
month information. In the rest of the file, each line contains the staff number, number of days
absent, number of complete 15-minute periods being late, and the number of complete overtime
work hours of an employee. Both files are sorted by the staff number in increasing order. The
following is an example of theemployees.txtandmonthly-attendance.txtfiles.

employees.txt

```
1009CHAN TAI MAN M1992-01-012007-02-04ITD
1077WONG ALICE F1990-10-102007-02-04ITD
1823WONG SIU MING M1991-08-082007-02-04HRD
```
monthly-attendance.txt

```
2019-
1009001002001
1077000000000
1823000002000
```

At every midnight, the System will generate one file: attendance.txt. This file contains all
employee arrival/departure information recorded by the attendance reader on the previous day.
The first line of the file is the date information. If it is the first day of the month, we need to
reset the monthly attendance summary for all employees and also change the month information
on the first line of the filemonthly-attendance.txt. The rest of the file contains one tapping
record per line, which includes the staff number, status and tapping time of an employee. There
are two possible statuses:ARRIVEandLEAVE. Records withARRIVEstatuses show the time of
arrival for the corresponding employee. Records withLEAVEstatuses show the time of departure.
The attendance reader will mark all records before 5:00pm asARRIVEand all records at or after
5:00pm asLEAVE. Records in this file will be sorted by the tapping time in chronological order.

Every employee should have oneARRIVEand oneLEAVErecord each day. If there is more than
oneARRIVErecord for the same employee, we handle only the firstARRIVErecord. Similarly,
if there is more than oneLEAVErecord for the same employee, we handle only the firstLEAVE
record. If an employee has either theARRIVEorLEAVErecords (but not both) missing, we
should report the employee’s name to the human resources manager with theSUSPICIOUSstatus
and should not update the monthly attendance summary for that employee. If an employee has
no attendance records in a particular day, the employee is considered absent.

The following is an example of theattendance.txtfile:

### 2019-01-

### 1077ARRIVE2019-01-04-09:

### 1823ARRIVE2019-01-04-09:

### 1009ARRIVE2019-01-04-10:

### 1077LEAVE 2019-01-04-18:

### 1009LEAVE 2019-01-04-19:

From the above example, we can see only staff 1009 was late for work, and would be penalized
for being late for two counts of complete 15-minute periods. We report staff 1009 to the human
resources manager with theLATEstatus. Also, we can see staff 1077 and 1009 worked overtime.
They would be rewarded with one and two overtime working hours respectively. Moreover, we
can see staff 1823 had only oneARRIVErecord, we should report to the manager with the
SUSPICIOUSstatus and not update the monthly attendance summary for staff 1823.

The System will also generate a daily summary for the human resources manager:summary.txt.
The file consists of three parts. The first part of the file gives the headers of the summary. The
second part of the file contains the attendance summary for all employees. Each line contains
the staff number, name, department and attendance status of an employee. The status can be
PRESENT,LATE,ABSENT, orSUSPICIOUS. If an employee has no attendance records, the
status should beABSENT. If an employee has anARRIVErecord and oneLEAVErecord, the
status should bePRESENTfor those arriving on time orLATEfor those arriving late. Otherwise,
the status should beSUSPICIOUS. The last part of the file reports the occurrence of each status.

The following is an example of thesummary.txtfile based on the above exampleattendance.txt
andemployees.txtfiles,

```
Daily Attendance Summary
Date: January 4, 2019
Staff-ID Name Department Status
--------------------------------------------------------------
1009 CHAN TAI MAN ITD LATE
1077 WONG ALICE ITD PRESENT
1823 WONG SIU MING HRD SUSPICIOUS
--------------------------------------------------------------
Number of Presences: 1
```

```
Number of Absences: 0
Number of Late Arrivals: 1
Number of Suspicious Records: 1
```
To sum up, you are required to implement a program to update the monthly attendance summary
and generate a daily attendance summary based on the employee information and the daily atten-
dance records. Your calculations should be based on the policy described above. Here is a diagram
summarizing the relationship of all files.

```
Figure 1: Relationship of input and output files
```
## 2.2 General Specification

You are required to write two programs, one in FORTRAN and the other one in COBOL, for the
attendance tracking module of the System. You should name your FORTRAN source as “atd.for”
and your COBOL source as “atd.cob”.

```
1.Input and Output Specification
Your programs should read three input files:employees.txt,attendance.txt, and
monthly-attendance.txt, which contain employees’ information, daily and monthly atten-
dance records. Your program should compute the number of complete 15-minute periods
being late, number of complete overtime work hours, number of days absent, and the status
of every employee. These calculations should be strictly based on the policy described above.
Your program should output two files for updating the monthly attendance information and
generating a summary for the human resources manager. The output files should follow the
description in Section 2.4.
For FORTRAN, the name of the input files should be passed to your program as parameters
in the command line:
```
```
./atd employees.txt attendance.txt monthly-attendance.txt
```
```
For COBOL, you should “hardcode” the name of the input files in your program EXACTLY
as “employees.txt”, “attendance.txt” and “monthly-attendance.txt”.
The naming of output files should be as follows:
Output ASCII filenames for FORTRAN:monthly-attendancefor.txt,summaryfor.txt
Output ASCII filenames for COBOL:monthly-attendancecob.txt,summarycob.txt
```
```
2.Restrictions on using FORTRAN and COBOL
In order to force you to program as in the old days, ONLY 2 keywords are allowed in
```

```
selection and loop statements: “IF” and “GOTO”. You are not allowed to use modern control
constructs, such as if-then-else or while loop. Using any other keywords will receive marks
deduction.
```
```
3.Error Handling
The programs should also handle possible errors gracefully by printing meaningful error
messages to the standard output. For example, failure to open a non-existing file. However,
youCANassume that the input files are free of errors.
```
```
4.Good Programming Style
A good programming style not only improves your grade but also helps you a lot in debugging.
Poor programming style will receive marks deduction. Construct your program with good
readability and modularity. Provide sufficient documentation by commenting your codes
properly but never redundantly. Divide up your programs into subroutines instead of clogging
the main program. The main section of your program should only handle the basic file
manipulation such as file opening and closing, and subprogram calling. The main purpose of
programming is not just to make the program right but also make it good.
```
```
5.Other Notes
You areNOTallowed to implement your program in another language (e.g. Assembly/C/C++)
and then initiate system calls or external library calls in FORTRAN and COBOL. Your source
codes will be compiled and PERUSED, and the object code tested!
Do not implement your programs in multiple source files. Although FORTRAN and COBOL
do allow you to build a project with subroutines scattered among multiple source files, you
should only submit one source file for each language.
NO PLAGIARISM!!!! You are free to design your own algorithm and code your own
implementation, but you should not “borrow” codes from your classmates. If you use an
algorithm or code snippet that is publicly available or use codes from your classmates or
friends, be sure to DECLARE it in the comments of your program. Failure to comply will
be considered as plagiarism.
A crash introduction to FORTRAN and COBOL will be given in the upcoming tutorials.
Please DO attend the tutorials to get a brief idea on these two languages, and then learn
the languages by yourselves. For a more in-depth study, we encourage students to search
relevant resources on the Internet (just Google it!).
```
## 2.3 Input File Format Specification

There are three input files:employees.txt,attendance.txt, andmonthly-attendance.txt. All
input files are in plain ASCII texts. Each line is ended with the characters “\r\n”. You should
strictly follow the format as stated in the following.

- The dates used in all files are specified by a string of the form: YYYY-MM-DD, where YYYY,
    MM, and DD represent a 4-digit year, a 2-digit month, and a 2-digit day respectively. If a
    month of a day has only one digit, start the number with zero. For example, the month of
    May is specified as “05”.
- Each line ofemployees.txtcontains eight fields of fixed lengths of an employee.

```
1.Staff number: a 4-digit string. If it is less than 1000, the left side of the number will be
padded with zero(es).
2.Last name: a string of length 10. If there are less than 10 alphanumeric characters in
the name, spaces would be padded at the right side of the name.
3.First name: a string of length 20. If there are less than 20 alphanumeric characters in
the name, spaces would be padded at the right side of the name.
```

```
4.Gender: a single character. It is always ‘M’ or ‘F’.
5.Date of birth: a string of length 10. It is in date format.
6.Hiring date: a string of length 10. It is in date format.
7.Department: a string of length 3. It is an abbreviation of the department. It always
consists of 3 capital letters.
8.Monthly salary: a 6-digit string. It is between 0 to 999999. If it is less than 100000, the
left side of the number will be padded with zero(es).
```
- Fileattendance.txtis as follows. The first line is the date in date format. The rest of the
    file contains three fields of fixed lengths of a daily attendance record of an employee on each
    line.

```
1.Staff number: a 4-digit string. If it is less than 1000, the left side of the number will be
padded with zero(es).
2.Status: a string of length 6. It is always “ARRIVE”, or “LEAVE”. If length of status
is less than 6, spaces would be padded on the right side of the status.
3.Time: a 16-character string of the form YYYY-MM-DD-HH:NN, where YYYY, MM,
DD, HH, and NN represent a 4-digit year, a 2-digit month, a 2-digit day, a 2-digit hour,
and a 2-digit minute. Time is written in 24-hour clock convention. If a 2-digit number
is less than 10, there is a leading zero.
```
- Filemonthly-attendance.txtis as follows. The first line is month information, in YYYY-
    MM format, representing a 4-digit year and a 2-digit month. The rest of the file contains
    four fields of fixed lengths of a monthly attendance record of an employee on each line. The
    number of lines in this file should be the same as that in theemployees.txtfile.

```
1.Staff number: a 4-digit string. If it is less than 1000, the left side of the number will be
padded with zero(es).
2.Number of days of absent: a 3-digit string. If it is less than 100, the left side of the
number will be padded with zero(es).
3.Number of complete 15-minute periods being late: a 3-digit string. If it is less than 100,
the left side of the number will be padded with zero(es).
4.Number of overtime work hours: a 3-digit string. If it is less than 100, the left side of
the number will be padded with zero(es).
```
You may make the following assumptions on the files:

- All dates and times are valid.
- Maximum number of employees is 9999.
- Fileemployees.txtis sorted by staff number in ascending order.
- Fileattendance.txtis sorted by time in chronological order from the second line onward.
- Filemonthly-attendance.txtis sorted by staff number in ascending order from the second
    line onward.
- The timestamp of the first attendance record in fileattendance.txtis on or after YYYY-
    MM-DD-00:00, where YYYY-MM-DD is the date on the first line of the same file.
- The timestamp of the last attendance record in fileattendance.txtis on or before YYYY-
    MM-DD-23:59, where YYYY-MM-DD is the date on the first line of the same file.
- Each line respects the description in this specification.


The following are examples of the input files.
employees.txt

1023CHAN TAI MAN M1992-01-012007-02-04ITD
1024WONG SIU MING M1993-11-112007-02-04ITD
1025A123456789B1234567890123456789F1993-11-112007-02-04ITD
1026PAN PETER M1993-11-112007-02-04HRD

attendance.txt

2018-09-
1026ARRIVE2018-09-29-10:
1023ARRIVE2018-09-29-10:
1025LEAVE 2018-09-29-20:
1026LEAVE 2018-09-29-20:
1023LEAVE 2018-09-29-20:

monthly-attendance.txt

2018-
1023001000000
1024000001000
1025001011002
1026003000001

## 2.4 Output File Format Specification

There should be two output files,monthly-attendanceXXX.txt,summaryXXX.txt(XXX
=fororcob), containing the updated monthly attendance summary and the daily attendance
summary. Each line is ended with the characters “\r\n”. You should strictly follow the format as
stated in the following.

- Filemonthly-attendanceXXX.txtshould have the same format asmonthly-attendance.txt
    as described in Section 2.3. It should be sorted by staff number in ascending order from sec-
    ond line onward.
- FilesummaryXXX.txtis as follows. The file contains three parts.
    - The first part is the header of summary. It consists of four lines.
       1. The first line is fixed as “Daily Attendance Summary”.
       2. The second line is the date. It begins with “Date: ”, followed by the date informa-
          tion, which is the same as the date information inattendance.txt. However, the
          date is written with month, day, and year in order with a comma before the year.
          Month is given in english. There are no leading zeroes. The date has length of 18.
          Space(s) is padded on the right of the date if needed. For example, “2018-01-02”
          inattendance.txtbecomes “January 2, 2018 ” insummary.txt.
       3. The third line is the field header. It begins with “Staff-ID Name”, followed by 28
          spaces, and followed by “Department Status”.
       4. The fourth line contains 62 “-”.
    - The second part is the attendance summary for all employees. Each line contains four
       fields of fixed lengths of attendance summary. The number of lines in this file is the
       same as that inemployees.txt. It should be sorted by staff number in ascending order.
          1.Staff number,Last name,First name,Department: same information and format
             fromemployees.txt, i.e. strings of length 4, 10, 20, 3, respectively, with zero(es)


```
or spaces padded if needed. Staff number,last name, anddepartmentare aligned
with the field headersStaff-ID,Name, andDepartmentrespectively. There is a
space betweenlast nameandfirst name.
2.Status: a string of length 10. It is always “PRESENT”, “LATE”, “ABSENT”, or
“SUSPICIOUS”. If the length of status is less than 10, spaces should be padded on
the right of the status. It is aligned with the field headerStatus.
```
- The last part summerizes the occurrence of each status. It consists of five lines.
    1. The first line contains 62 “-”.
    2. The second line begins with “Number of Presences:”, followed by the number
       of staff with the “PRESENT” status.
    3. The third line begins with “Number of Absences: ”, followed by the number of
       staff with the “ABSENT” status.
    4. The fourth line begins with “Number of Late Arrivals:”, followed by the num-
       ber of staff with the “LATE” status.
    5. The fifth line begins with “Number of Suspicious Records:”, followed by the
       number of staff with the “SUSPICOUS” status.
    6. All numbers are of length 4. There are no leading zeroes. If a number is less than
       1000, the left side of the number is padded with space(s).

Please make sure that each employee inemployees.txthas a corresponding line in both the
monthly-attendanceXXX.txtandsummaryXXX.txtfiles.

The following is the content of the output files based on the sample input files given.
monthly-attendanceXXX.txt

2018-
1023001001003
1024001001000
1025001011002
1026003000004

summaryXXX.txt

Daily Attendance Summary
Date: September 29, 2018
Staff-ID Name Department Status
--------------------------------------------------------------
1023 CHAN TAI MAN ITD LATE
1024 WONG SIU MING ITD ABSENT
1025 A123456789 B1234567890123456789 ITD SUSPICIOUS
1026 PAN PETER HRD PRESENT
--------------------------------------------------------------
Number of Presences: 1
Number of Absences: 1
Number of Late Arrivals: 1
Number of Suspicious Records: 1
