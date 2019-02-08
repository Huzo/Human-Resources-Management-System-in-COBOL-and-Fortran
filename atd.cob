      *
      *CSCI3180 Principles of Programming Languages
      *
      *--- Declaration ---
      *
      *I declare that the assignment here submitted is original
      *except for source material explicitly acknowledged. I also
      *acknowledge that I am aware of University policy and regulations
      *on honesty in academic work, and of the disciplinary guidelines
      *and procedures applicable to breaches of such policy
      *and regulations, as contained in the website
      *http://www.cuhk.edu.hk/policy/academichonesty/
      *
      *Assignment 1
      *Name : Huzeyfe KIRAN
      *Student ID : 1155104019
      *Email Addr : 1155104019@link.cuhk.edu.hk

       identification division.
       program-id. atd.

       environment division.
       input-output section.
       file-control.
           select i-m-attendance-file
               assign to 'monthly-attendance.txt'
               organization is line sequential
               file status is fs-m.
           select i-attendance-file
               assign to 'attendance.txt'
               organization is line sequential.
           select i-employees-file
               assign to 'employees.txt'
               organization is line sequential
               file status is fs.
           select o-sorted-attendance-file
               assign to 'sorted-attendance.txt'
               organization is line sequential
               file status is fs-sorted.
           select o-m-attendance-file
               assign to 'monthly-attendancecob.txt'
               organization is line sequential.
           select o-summary-file
               assign to 'summarycob.txt'
               organization is line sequential
               file status is fs-sum.
           select temp-file
               assign to 'temp.txt'
               organization is line sequential
               file status is fs-temp.
           select work-file-1
               assign to 'temp.txt'
               organization is line sequential.
           select work-file-2
               assign to 'temp.txt'
               organization is line sequential.

       data division.
       file section.
       fd i-employees-file.
       01 staff-rec.
           02 staff-number pic x(4).
           02 last-name pic x(10).
           02 first-name pic x(20).
           02 gender pic x(1).
           02 date-of-birth pic x(10).
           02 hiring-date pic x(10).
           02 department pic x(3).
           02 monthly-salary pic x(6).

       fd i-attendance-file.
       01 attendance-date-record.
           02 attendance-date pic x(10).
       01 attendance-info.
           02 attendance-staff-number pic x(4).
           02 status-al pic x(6).
           02 time-al pic x(16).

       fd i-m-attendance-file.
       01 m-attendance-date-record.
           02 i-m-year pic 9999.
           02 filler pic x(1).
           02 i-m-month pic 99.
       01 staff-record.
           02 monthly-staff-number pic 9999.
           02 no-days-absent pic 999.
           02 fifteen_period pic 999.
           02 overtime_work_hour pic 999.

       fd o-m-attendance-file.
       01 o-m-attendance-date-record.
           02 o-m-year pic 9999.
           02 filler pic x(1).
           02 o-m-month pic 99.
           02 o-m-r-1 pic xx.
       01 o-m-staff-record.
           02 o-m-staff-number pic 9999.
           02 no-days-absent pic 999.
           02 fifteen_period pic 999.
           02 overtime_work_hour pic 999.
           02 o-m-r-2 pic xx.

       fd o-summary-file.
       01 summary-record pic x(80).

       fd temp-file.
       01 tmp-m-attendance-date-record.
           02 tmp-m-attendance-date pic x(7).
       01 tmp-staff-record.
           02 tmp-monthly-staff-number pic x(4).
           02 tmp-no-days-absent pic x(3).
           02 tmp-fifteen_period pic x(3).
           02 tmp-overtime_work_hour pic x(3).

       sd work-file-1.
       01 w-attendance-date-record.
           02 w-attendance-date pic x(10).
       01 w-attendance-info.
           02 w-attendance-staff-number pic x(4).
           02 w-status-al pic x(6).
           02 w-time-al pic x(16).

       sd work-file-2.
       01 w-m-attendance-date-record.
           02 w-m-attendance-date pic x(7).
       01 w-staff-record.
           02 w-monthly-staff-number pic x(4).
           02 w-no-days-absent pic x(3).
           02 w-fifteen_period pic x(3).
           02 w-overtime_work_hour pic x(3).

       working-storage section.
       01 constant-text-1 pic x(26)
       value "Daily Attendance Summary\r".
       01 header-date.
           02 constant-text-1-1 pic x(6) value "Date: ".
           02 summary-date pic x(20).

       01 constant-text-2.
           02 constant-text-2-1 pic x(13) value "Staff-ID Name".
           02 constant-text-2-2 pic x(28) value spaces.
           02 constant-text-2-3 pic x(19) value "Department Status\r".
       01 constant-text-3.
           02 constant-text-3-1 pic x(20) value '--------------------'.
           02 constant-text-3-2 pic x(20) value '--------------------'.
           02 constant-text-3-3 pic x(20) value '--------------------'.
           02 constant-text-3-4 pic x(4) value '--\r'.
       01 o-staff-record.
           02 o-staff-number pic x(4).
           02 just-empty pic x(5) value spaces.
           02 o-last-name pic x(10).
           02 o-first-name pic x(20).
           02 empty-area-2 pic x(2) value spaces.
           02 o-department pic x(3).
           02 empty-area pic x(8) value spaces.
           02 o-staff-status pic x(10).
           02 filler pic xx value '\r'.
       01 constant-text-4.
           02 constant-text-4-1 pic x(20) value '--------------------'.
           02 constant-text-4-2 pic x(20) value '--------------------'.
           02 constant-text-4-3 pic x(20) value '--------------------'.
           02 constant-text-4-4 pic x(4) value '--\r'.
       01 no-of-presences-part.
           02 constant-text-5 pic x(20) value
           "Number of Presences:".
           02 no-presences pic ZZZZ.
           02 filler pic xx value '\r'.
       01 no-of-absences-part.
           02 constant-text-6 pic x(19) value
           "Number of Absences:".
           02 no-absences pic ZZZZ.
           02 filler pic xx value '\r'.
       01 no-of-late-arrivals-part.
           02 constant-text-7 pic x(24) value
           "Number of Late Arrivals:".
           02 no-late-arrivals pic ZZZZ.
           02 filler pic xx value '\r'.
       01 no-of-suspicious-records-part.
           02 constant-text-8 pic x(29) value
           "Number of Suspicious Records:".
           02 no-suspicious-records pic ZZZZ.
           02 filler pic xx value '\r'.


       01 ws-employees-table.
           05 ws-employees.
               10 ws-staff-number pic x(4).
               10 ws-last-name pic x(10).
               10 ws-first-name pic x(20).
               10 ws-gender pic x(1).
               10 ws-date-of-birth pic x(10).
               10 ws-hiring-date pic x(10).
               10 ws-department pic x(3).
               10 ws-monthly-salary pic x(6).

       01 ws-attendance.
           02 ws-attendance-info.
               03 ws-attendance-staff-number pic x(4).
               03 ws-status-al pic x(6).
               03 ws-year-al pic 9999.
               03 one-dash-1 pic x value '-'.
               03 ws-month-al pic 99.
               03 one-dash-2 pic x value '-'.
               03 ws-day-al pic 99.
               03 one-dash-3 pic x value '-'.
               03 ws-hour-al pic 99.
               03 one-dash-4 pic x value '-'.
               03 ws-minute-al pic 99.


       01 fs pic 99.
       01 fs-temp pic 99.
       01 fs-sorted pic 99.
       01 fs-m pic 99.
       01 fs-sum pic 99.

       01 ws-attendance-d-r.
           02 ws-attendace pic x(7).

       01 max-value pic 9999 value 9999.
       01 dummy-string pic x.

       01 tmp-date pic x(15).

       01 ws-attendance-date.
           02 ws-attendance-year pic xxxx.
           02 filler pic x(1).
           02 ws-attendance-month pic xx.
           02 filler pic x(1).
           02 ws-attendance-day pic zz.


       01 ws-arrive-leave pic 99 value 00.
      *our control case of every single employee.
      *00=no arrive no leave
      *10=arrive no leave
      *01=leave no arrive
      *11=arrive and leave

       01 ws-presence-count pic 9 value 0.
       01 ws-absence-count pic 9 value 0.
       01 ws-late-arrival-count pic 9 value 0.
       01 ws-suspicious-count pic 9 value 0.

       01 ws-late-quarter-count pic 9 value 0.
       01 ws-overtime-count pic 9 value 0.
       01 ws-absent-count pic 9 value 0.

       01 ws-dummy-number pic 9.
       01 ws-dummy-day pic 99.
       01 ws-dummy-day-1 pic z.
       01 ws-dummy-day-2 pic zz.

       procedure division.
       main-paragraph.
           perform get-attendance-date.

           perform sort-attendance-file.

           perform initialize-file-variables.

       stop run.


       initialize-file-variables.
      *function to write summary file.
           open output o-summary-file
               perform get-summary-date.

      *********header part**********
               write summary-record from constant-text-1.
               write summary-record from header-date.
               write summary-record from constant-text-2.
               write summary-record from constant-text-3.
      ******************************

      *employee list with status and department
               open input o-sorted-attendance-file
                   open input i-employees-file
                       perform algo-read-employees.
                       perform algo-read-attendance.
                       perform read-monthly-attendance-file-start-algo.
                       if fs-sum is equal to 00 then
                           perform continue-write-summary.
      **************************************************************
       continue-write-summary.
           close i-employees-file
           close o-sorted-attendance-file
           write summary-record from constant-text-4.
      *counts of absences, presences etc.
           move ws-presence-count to no-presences.
           write summary-record from no-of-presences-part.
           move ws-absence-count to no-absences.
           write summary-record from no-of-absences-part.
           move ws-late-arrival-count to no-late-arrivals.
           write summary-record from no-of-late-arrivals-part.
           move ws-suspicious-count to no-suspicious-records.
           write summary-record from no-of-suspicious-records-part.
           close o-summary-file.

       read-monthly-attendance-file-start-algo.
      *first read the monthly date and write it to output monthly file.
      *then perform our algo.
           open input i-m-attendance-file.
               open output o-m-attendance-file.
               read i-m-attendance-file into o-m-attendance-date-record
               end-read.
               perform write-monthly-date

               perform algo-overall.
               close o-m-attendance-file
           close i-m-attendance-file.

       read-monthly-record.
           if(fs-m is equal to 00) then
           read i-m-attendance-file into o-m-staff-record
           end-read
               if ws-attendance-day = 01 then
                   move 000 to fifteen_period of o-m-staff-record
                   move 000 to overtime_work_hour of o-m-staff-record
                   move 000 to no-days-absent of o-m-staff-record
               end-if.

       write-monthly-record.
           add ws-late-quarter-count to fifteen_period
           of o-m-staff-record giving fifteen_period of o-m-staff-record
           add ws-overtime-count to
           overtime_work_hour of o-m-staff-record
           giving overtime_work_hour of o-m-staff-record
           add ws-absent-count to no-days-absent of o-m-staff-record
           giving no-days-absent of o-m-staff-record
           move '\r' to o-m-r-2
           if(overtime_work_hour of o-m-staff-record > 030) then
               move 030 to overtime_work_hour of o-m-staff-record
           end-if
           if fs-m is equal to 00 then
               write o-m-staff-record.

      ************************************************************

       get-attendance-date.
      *get attendance date from attendance file
           open input i-attendance-file.
               read i-attendance-file into ws-attendance-date
               end-read.
           close i-attendance-file.

       get-summary-date.
      *get the date in words for summary.
           if ws-attendance-month = "01" then
               move "January" to tmp-date.
           if ws-attendance-month = "02" then
               move "February" to tmp-date.
           if ws-attendance-month = "03" then
               move "March" to tmp-date.
           if ws-attendance-month = "04" then
               move "April" to tmp-date.
           if ws-attendance-month = "05" then
               move "May" to tmp-date.
           if ws-attendance-month = "06" then
               move "June" to tmp-date.
           if ws-attendance-month = "07" then
               move "July" to tmp-date.
           if ws-attendance-month = "08" then
               move "August" to tmp-date.
           if ws-attendance-month = "09" then
               move "September" to tmp-date.
           if ws-attendance-month = "10" then
               move "October" to tmp-date.
           if ws-attendance-month = "11" then
               move "November" to tmp-date.
           if ws-attendance-month = "12" then
               move "December" to tmp-date.

           move ws-attendance-day to ws-dummy-day.

           if ws-dummy-day >= 01 and ws-dummy-day <=09 then
               move ws-dummy-day to ws-dummy-day-1
               string tmp-date delimited by space
                  " " delimited by size
                  ws-dummy-day-1 delimited by size
                  ", " delimited by size
                  ws-attendance-year delimited by size
                  '\r' delimited by size
                  into summary-date
               end-string
           end-if
           if ws-dummy-day >= 10 then
               move ws-dummy-day to ws-dummy-day-2
               string tmp-date delimited by space
                  " " delimited by size
                  ws-dummy-day-2 delimited by size
                  ", " delimited by size
                  ws-attendance-year delimited by size
                  '\r' delimited by size
                  into summary-date
               end-string
           end-if.





       sort-attendance-file.
      *sort attendance file for algo
           sort work-file-1 on ascending key w-attendance-staff-number
           using i-attendance-file giving o-sorted-attendance-file.


       algo-read-employees.
      *read employees from employees.txt
           if fs = 00 then
               read i-employees-file into ws-employees
               end-read.

       algo-read-attendance.
      *read attendance from sorted attendance file.
           if fs-sorted = 00 then
               read o-sorted-attendance-file into ws-attendance
               end-read
               if ws-attendance(5:1) is equal to '-'
               and fs-sorted = 00 then
                   perform algo-read-attendance
               end-if
           end-if
           if fs-sorted is not equal to 00 then
               if fs-sum is equal to 00 then
                   perform continue-write-summary
               end-if
           end-if.

       algo-overall.
           if ws-staff-number is not equal to
           ws-attendance-staff-number then
      *when the employee record is not found

               if ws-arrive-leave = 10 then
      *when an employee has arrive but no leave
                   move "SUSPICIOUS" to o-staff-status
                   perform reset-monthly-count
                   move 00 to ws-arrive-leave
                   add 1 to ws-suspicious-count
                   giving ws-suspicious-count
                   perform algo-write-staff-record
                   perform algo-read-employees
                   perform algo-overall
               end-if
               if ws-arrive-leave = 00
      *when an employee has no arrive and no leave
                   move "ABSENT" to o-staff-status
                   if fs-sorted=00 and fs=00 then
                       perform compute-absent-count
                       add 1 to ws-absence-count giving ws-absence-count
                       perform algo-write-staff-record
                       perform algo-read-employees
                       perform algo-overall
                   end-if
               end-if
               if ws-arrive-leave = 01
      *when an employee has suspicios leave
                   move 00 to ws-arrive-leave
                   perform algo-read-employees
                   perform algo-overall
               end-if
               if ws-arrive-leave = 11
      *when an employee has arrive and leave
                   move 00 to ws-arrive-leave
                   perform algo-read-employees
                   perform algo-overall
               end-if
           end-if
           if ws-staff-number = ws-attendance-staff-number then
      *when the employee record is matched

               if ws-arrive-leave=00 and ws-status-al="ARRIVE" then
      *first arrive
                   move 10 to ws-arrive-leave
                   if ws-hour-al<10
                   or ws-hour-al=10 and ws-minute-al<15 then
                       move "PRESENT" to o-staff-status
                       move 0 to ws-late-quarter-count
                   end-if
                   if ws-hour-al > 10
                   or ws-hour-al=10 and ws-minute-al>=15 then
                       move "LATE" to o-staff-status
                       perform compute-late-quarter
                   end-if
                   perform algo-read-attendance
                   perform algo-overall
               end-if
               if ws-arrive-leave=00 and ws-status-al="LEAVE" then
      *leave without arriving
                   move "SUSPICIOUS" to o-staff-status
                   perform reset-monthly-count
                   add 1 to ws-suspicious-count
                   giving ws-suspicious-count
                   move 01 to ws-arrive-leave
                   perform algo-write-staff-record
                   perform algo-read-attendance
                   perform algo-overall
               end-if
               if ws-arrive-leave=10 and ws-status-al="ARRIVE" then
      *arrive when already arrived (must ignore)
                   perform algo-read-attendance
                   perform algo-overall
               end-if
               if ws-arrive-leave=10 and ws-status-al="LEAVE" then
      *leave after arrive (present)
                   move 11 to ws-arrive-leave
                   if ws-hour-al > 17 or
                   ws-hour-al=17 and ws-minute-al >= 30 then
                       perform compute-overtime-count
                   if o-staff-status = "PRESENT" then
                       add 1 to ws-presence-count
                       giving ws-presence-count
                   end-if
                   if o-staff-status = "LATE" then
                       add 1 to ws-late-arrival-count
                       giving ws-late-arrival-count
                   end-if
                   perform algo-write-staff-record
                   perform algo-read-attendance
                   perform algo-overall
               end-if
               if ws-arrive-leave=01 and ws-status-al="LEAVE" then
      * leave when already leave with suspicious
                   perform algo-read-attendance
                   perform algo-overall
               end-if
               if ws-arrive-leave=11 and ws-status-al="ARRIVE" then
      *             impossible case
                   perform algo-read-employees
                   perform algo-read-attendance
                   move 00 to ws-arrive-leave
                   perform algo-overall
               end-if
               if ws-arrive-leave=11 and ws-status-al="LEAVE" then
      *leave when already left (must ignore)
                   perform algo-read-attendance
                   perform algo-overall
               end-if
           end-if.

       algo-write-staff-record.
      *write the staff information for summary.
           move ws-staff-number to o-staff-number
           move ws-last-name to o-last-name
           move ws-first-name to o-first-name
           move ws-department to o-department
           write summary-record from o-staff-record
           perform read-monthly-record
           perform write-monthly-record.

       compute-late-quarter.
           move 0 to ws-late-quarter-count
           if ws-hour-al is not greater than 10 then
               divide ws-minute-al by 15 giving ws-late-quarter-count
           end-if
           if ws-hour-al > 10 then
               divide ws-minute-al by 15 giving ws-late-quarter-count
               subtract 10 from ws-hour-al giving ws-dummy-number
               multiply ws-dummy-number by 4 giving ws-dummy-number
               add ws-late-quarter-count to ws-dummy-number
               giving ws-late-quarter-count.

       compute-overtime-count.
           move 0 to ws-overtime-count
           subtract 17 from ws-hour-al giving ws-overtime-count.

       compute-absent-count.
           move 1 to ws-absent-count.

       reset-monthly-count.
           move 0 to ws-late-quarter-count
           move 0 to ws-overtime-count
           move 0 to ws-absent-count.

       write-monthly-date.
           move ws-attendance-year to o-m-year
           move ws-attendance-month to o-m-month
           move '\r' to o-m-r-1
           write o-m-attendance-date-record.


       end program atd.
