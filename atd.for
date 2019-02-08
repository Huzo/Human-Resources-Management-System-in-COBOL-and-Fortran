*
* CSCI3180 Principles of Programming Languages
*
* --- Declaration ---
*
* I declare that the assignment here submitted is original
* except for source material explicitly acknowledged. I also acknowledge
* that I am aware of University policy and regulations on honesty in academic
* work, and of the
* disciplinary guidelines and procedures applicable to breaches of such policy
* and regulations, as contained in the website
* http://www.cuhk.edu.hk/policy/academichonesty/
*
* Assignment 1
* Name : Huzeyfe KIRAN
* Student ID : 1155104019
* Email Addr : 1155104019@link.cuhk.edu.hk
*
      program atd
      implicit none
      character*10 a_date, m_date
      character*26 arr(1000)
      character*2 d
      integer fs_a,arr_size, n_p,n_a
      integer n_l, n_s
      n_p = 0
      n_a = 0
      n_l = 0
      n_s = 0

* open required files
      call o_attendance_f()
      call o_employees_f()
      call o_summary_f()
      call o_m_attendance_f()
      call o_r_attendance_f()

* read attendance date
      call r_a_date(a_date, fs_a)
      d = a_date (9:10)

* create and fill an array consisting of attendance records
      call fill_attendance_arr(arr,fs_a,arr_size)
* sort the array
      call sort_arr(arr,arr_size)

* read monthly attendance date
      call r_m_date(m_date)
* write monthly attendance date
      call w_m_date(m_date)

* write summary (also start algo for staff records in summary)
      call create_summary(a_date,n_p,n_a,n_l,n_s,arr,arr_size,d)

      end

      subroutine create_summary(a_date,n_p,n_a,n_l,n_s,arr,arr_size,d)
* subroutine for creating summary and starting the algorithm
      character*10 a_date
      character*26 arr(1000)
      character*64 dashes
      character*31 dashes_1, dashes_2
      character*58 dummy
      character*2 d
      integer n_p,n_a,n_l,n_s,arr_size

* write the header.
      write(4,'(A)') 'Daily Attendance Summary\r'
      call w_summary_date(a_date)
      dummy = 'Staff-ID Name                            '
      dummy = dummy(1:41)//'Department Status'
      write(4,'(A)') dummy//'\r'
      dashes_1 = '-------------------------------'
      dashes_2 = '-------------------------------'
      dashes = dashes_1//dashes_2//'\r'
      write(4,'(A)') dashes
* start the algorithm for summary staff record algorithm
      call algo(arr,arr_size,n_p,n_a,n_l,n_s,d,dashes)

* now continue summary by writing the other half
      return
      end

      subroutine continue_summary(dashes,n_p,n_a,n_l,n_s)
* subroutine to continue writing the summary's latter half
      character*64 dashes
      integer n_p, n_a, n_l, n_s
      write(4,'(A)') dashes
      write(4,'(A,I4,A)') 'Number of Presences:', n_p,'\r'
      write(4,'(A,I4,A)') 'Number of Absences:', n_a,'\r'
      write(4,'(A,I4,A)') 'Number of Late Arrivals:', n_l,'\r'
      write(4,'(A,I4,A)') 'Number of Suspicious Records:', n_s,'\r'
      call c_summary_f()
      return
      end

      subroutine algo(arr,arr_size,n_p,n_a,n_l,n_s,d,dashes)
* algo to write summary records and monthly records
      character*26 arr(1000)
      integer staff_id, arr_size, fs_e,i,a_id,n_p,n_a,n_l,n_s,a_l
      integer lq_c, o_c
      character*2 h,m
      character*6 s
      character*10 stat
      character*3 dept
      character*20 fname
      character*10 lname
      character*2 d
      character*64 dashes
      lq_c = 0
      o_c = 0
      fs_e = 0
      n_p = 0
      n_a = 0
      n_l = 0
      n_s = 0
      i=1
      a_l = 00
* a_l is our state-variable (takes values: 00,01,11,10)

      if(fs_e.eq.0) goto 399
      goto 499
 399  call r_employees_f(staff_id,fname,lname,dept,fs_e)

* if we have not read all the attendance records yet
 400  if(i.gt.arr_size-1 .or. fs_e .ne. 00) goto 499
      read(arr(i)(1:4), '(I4)') a_id
      s = arr(i)(5:10)
      h = arr(i)(22:23)
      m = arr(i)(25:26)
      if(a_id.eq.staff_id) goto 401
      goto 419
 401  if(a_l.eq.00 .and. s.eq.'ARRIVE') goto 402
* first arrive
      goto 406
 402  a_l=10
      if(h.lt.'10'.or.h.eq.'10'.and. m.lt.'15') goto 403
      goto 404
 403  stat = 'PRESENT'
      lq_c = 0
      goto 400
 404  if(h.gt.'10'.or.h.eq.'10'.and.m.ge.'15') goto 405
 405  stat = 'LATE'
      call compute_lq(h,m,lq_c)
      i = i + 1
      goto 400

 406  if(a_l.eq.00 .and. s.eq.'LEAVE ') goto 407
* leave without arriving
      goto 408
 407  stat = 'SUSPICIOUS'
      lq_c = 0
      o_c = 0
      n_s = n_s + 1
      a_l=01
      call algo_w_staff(staff_id,fname,lname,dept,stat,lq_c,o_c,d)
      i = i + 1
      goto 400

 408  if(a_l.eq.10 .and.s.eq.'ARRIVE') goto 409
* arrive when already arrived (must ignore)
      goto 410
 409  i = i + 1
      go to 400

 410  if(a_l.eq.10 .and. s.eq.'LEAVE ') goto 411
* leave after arrive (present)
      goto 200
 411  a_l = 11
      if(h.gt.'17'.or.h.eq.'17'.and.m.ge.'30') goto 412
      goto 413
 412  call compute_overtime(h,m,o_c)
 413  if(stat.eq.'PRESENT') goto 414
      n_l = n_l + 1
      goto 415
 414  n_p = n_p + 1
 415  call algo_w_staff(staff_id,fname,lname,dept,stat,lq_c,o_c,d)
      i = i + 1
      goto 400

 200  if(a_l.eq.01 .and. s.eq.'LEAVE ') goto 201
* leave when already leave with suspicious
      goto 416
 201  i = i + 1
      goto 400

 416  if(a_l.eq.11 .and. s.eq.'ARRIVE') goto 417
* impossible case
      goto 418
 417  i = i + 1
      a_l = 00
      goto 399

 418  if(a_l.eq.11 .and. s.eq.'LEAVE ') i = i + 1
* leave when already arrived and left (must ignore)
      goto 400

 419  if(a_id .ne. staff_id) goto 420
* when staff id and attendance id are different
      goto 499
 420  if(a_l.eq.10) goto 421
* when an employee has arrive but no leave
      goto 422
 421  stat='SUSPICIOUS'
      lq_c = 0
      o_c = 0
      a_l=00
      n_s = n_s + 1
      call algo_w_staff(staff_id,fname,lname,dept,stat,lq_c,o_c,d)
      goto 399

 422  if(a_l.eq.00) goto 423
* when an employee has no arrive and no leave
      goto 210
 423  stat = 'ABSENT'
      lq_c = 0
      o_c = 0
      n_a = n_a + 1
      call algo_w_staff(staff_id,fname,lname,dept,stat,lq_c,o_c,d)
      goto 399

 210  if(a_l.eq.01) goto 211
* when an employee has suspicious leave
      goto 424
 211  a_l = 00
      goto 399

 424  if(a_l.eq.11) goto 425
* when an employee has arrive and leave
      goto 399
 425  a_l = 00
      goto 399
 499  call continue_summary(dashes,n_p,n_a,n_l,n_s)
      return
      end

      subroutine compute_lq(hour,minute,lq_count)
* subroutine to compute late quarters (15 mins) of a staff
      integer h,m,lq_count,i,j
      character*2 hour,minute
      read(hour,'(I2)') h
      read(minute,'(I2)') m
      i = 0
      if(h.le.10) goto 600
      goto 601
 600  i = m/15
      lq_count = i
      if(h.gt.10) goto 601
      goto 602
 601  i = m/15
      j = h-10
      j = 4 * j
      i = i + j
      lq_count = i
 602  return
      end

      subroutine compute_overtime(hour,minute,overtime_count)
* subroutine to compute overtime hours of a staff
      integer h,m,overtime_count
      character*2 hour, minute
      read(hour,'(I2)') h
      read(minute,'(I2)') m
      overtime_count = h-17
 606  return
      end

      subroutine algo_w_staff(s_id,fname,lname,dept,stat,lq_c,o_c,d)
* writing a staff record to summary and monthly attendance
      character*20 fname
      character*10 stat,lname
      character*3 dept
      character*64 s
      character*2 d
      integer s_id, lq_c, o_c, a_c

      if(stat .eq. 'ABSENT') goto 607
      a_c = 0
      goto 608

 607  a_c = 1
 608  write(s,'(I4)') s_id
      s = s(1:9)//lname//fname//'  '//dept
      s = s(1:52)//stat//'\r'
      write(4,'(A)') s

      call algo_m_attendance(s_id, a_c, lq_c, o_c,d)
* write to monthly attendance as well
      return
      end


      subroutine w_summary_date(a_date)
* subroutine to write the summary's date
      character*10 a_date
      character*35 date_to_write
      integer i
      read(a_date(9:10),'(I2)') i

      if(i.lt.10) goto 449
* different cases when the day is two or one digit

 499  if(a_date(6:7).eq.'01') goto 500
      goto 501
 500  date_to_write = 'January '
      write(date_to_write, '(A,I2)') date_to_write(1:8),i
      write(date_to_write, '(A,A)') date_to_write(1:10), ', '
      write(date_to_write, '(A,A)')date_to_write(1:12),a_date(1:4)//'\r'
 501  if(a_date(6:7).eq.'02') goto 502
      goto 503
 502  date_to_write = 'February '
      write(date_to_write, '(A,I2)') date_to_write(1:9),i
      write(date_to_write, '(A,A)') date_to_write(1:11), ', '
      write(date_to_write, '(A,A)')date_to_write(1:13),a_date(1:4)//'\r'
 503  if(a_date(6:7).eq.'03') goto 504
      goto 505
 504  date_to_write = 'March '
      write(date_to_write, '(A,I2)') date_to_write(1:6),i
      write(date_to_write, '(A,A)') date_to_write(1:8), ', '
      write(date_to_write, '(A,A)')date_to_write(1:10),a_date(1:4)//'\r'
 505  if(a_date(6:7).eq.'04') goto 506
      goto 507
 506  date_to_write = 'April '
      write(date_to_write, '(A,I2)') date_to_write(1:6),i
      write(date_to_write, '(A,A)') date_to_write(1:8), ', '
      write(date_to_write, '(A,A)')date_to_write(1:10),a_date(1:4)//'\r'
 507  if(a_date(6:7).eq.'05') goto 508
      goto 509
 508  date_to_write = 'May '
      write(date_to_write, '(A,I2)') date_to_write(1:4),i
      write(date_to_write, '(A,A)') date_to_write(1:6), ', '
      write(date_to_write, '(A,A)')date_to_write(1:8),a_date(1:4)//'\r'
 509  if(a_date(6:7).eq.'06') goto 510
      goto 511
 510  date_to_write = 'June '
      write(date_to_write, '(A,I2)') date_to_write(1:5),i
      write(date_to_write, '(A,A)') date_to_write(1:7), ', '
      write(date_to_write, '(A,A)')date_to_write(1:9),a_date(1:4)//'\r'
 511  if(a_date(6:7).eq.'07') goto 512
      goto 513
 512  date_to_write = 'July '
      write(date_to_write, '(A,I2)') date_to_write(1:5),i
      write(date_to_write, '(A,A)') date_to_write(1:7), ', '
      write(date_to_write, '(A,A)')date_to_write(1:9),a_date(1:4)//'\r'
 513  if(a_date(6:7).eq.'08') goto 514
      goto 515
 514  date_to_write = 'August '
      write(date_to_write, '(A,I2)') date_to_write(1:7),i
      write(date_to_write, '(A,A)') date_to_write(1:9), ', '
      write(date_to_write, '(A,A)')date_to_write(1:11),a_date(1:4)//'\r'
 515  if(a_date(6:7).eq.'09') goto 516
      goto 517
 516  date_to_write = 'September '
      write(date_to_write, '(A,I2)') date_to_write(1:10),i
      write(date_to_write, '(A,A)') date_to_write(1:12), ', '
      write(date_to_write, '(A,A)')date_to_write(1:14),a_date(1:4)//'\r'
 517  if(a_date(6:7).eq.'10') goto 518
      goto 519
 518  date_to_write = 'October '
      write(date_to_write, '(A,I2)') date_to_write(1:8),i
      write(date_to_write, '(A,A)') date_to_write(1:10), ', '
      write(date_to_write, '(A,A)')date_to_write(1:12),a_date(1:4)//'\r'
 519  if(a_date(6:7).eq.'11') goto 520
      goto 521
 520  date_to_write = 'November '
      write(date_to_write, '(A,I2)') date_to_write(1:9),i
      write(date_to_write, '(A,A)') date_to_write(1:11), ', '
      write(date_to_write, '(A,A)')date_to_write(1:13),a_date(1:4)//'\r'
 521  if(a_date(6:7).eq.'12') goto 522
      goto 523
 522  date_to_write = 'December '
      write(date_to_write, '(A,I2)') date_to_write(1:9),i
      write(date_to_write, '(A,A)') date_to_write(1:11), ', '
      write(date_to_write, '(A,A)')date_to_write(1:13),a_date(1:4)//'\r'

 449  if(a_date(6:7).eq.'01') goto 550
      goto 551
 550  date_to_write = 'January '
      write(date_to_write, '(A,I1)') date_to_write(1:8),i
      write(date_to_write, '(A,A)') date_to_write(1:9), ', '
      write(date_to_write, '(A,A)')date_to_write(1:11),a_date(1:4)//'\r'
 551  if(a_date(6:7).eq.'02') goto 552
      goto 553
 552  date_to_write = 'February '
      write(date_to_write, '(A,I1)') date_to_write(1:9),i
      write(date_to_write, '(A,A)') date_to_write(1:10), ', '
      write(date_to_write, '(A,A)')date_to_write(1:12),a_date(1:4)//'\r'
 553  if(a_date(6:7).eq.'03') goto 554
      goto 555
 554  date_to_write = 'March '
      write(date_to_write, '(A,I1)') date_to_write(1:6),i
      write(date_to_write, '(A,A)') date_to_write(1:7), ', '
      write(date_to_write, '(A,A)')date_to_write(1:9),a_date(1:4)//'\r'
 555  if(a_date(6:7).eq.'04') goto 556
      goto 557
 556  date_to_write = 'April '
      write(date_to_write, '(A,I1)') date_to_write(1:6),i
      write(date_to_write, '(A,A)') date_to_write(1:7), ', '
      write(date_to_write, '(A,A)')date_to_write(1:9),a_date(1:4)//'\r'
 557  if(a_date(6:7).eq.'05') goto 558
      goto 559
 558  date_to_write = 'May '
      write(date_to_write, '(A,I1)') date_to_write(1:4),i
      write(date_to_write, '(A,A)') date_to_write(1:5), ', '
      write(date_to_write, '(A,A)')date_to_write(1:7),a_date(1:4)//'\r'
 559  if(a_date(6:7).eq.'06') goto 560
      goto 561
 560  date_to_write = 'June '
      write(date_to_write, '(A,I1)') date_to_write(1:5),i
      write(date_to_write, '(A,A)') date_to_write(1:6), ', '
      write(date_to_write, '(A,A)')date_to_write(1:8),a_date(1:4)//'\r'
 561  if(a_date(6:7).eq.'07') goto 562
      goto 563
 562  date_to_write = 'July '
      write(date_to_write, '(A,I1)') date_to_write(1:5),i
      write(date_to_write, '(A,A)') date_to_write(1:6), ', '
      write(date_to_write, '(A,A)')date_to_write(1:8),a_date(1:4)//'\r'
 563  if(a_date(6:7).eq.'08') goto 564
      goto 565
 564  date_to_write = 'August '
      write(date_to_write, '(A,I1)') date_to_write(1:7),i
      write(date_to_write, '(A,A)') date_to_write(1:8), ', '
      write(date_to_write, '(A,A)')date_to_write(1:10),a_date(1:4)//'\r'
 565  if(a_date(6:7).eq.'09') goto 566
      goto 567
 566  date_to_write = 'September '
      write(date_to_write, '(A,I1)') date_to_write(1:10),i
      write(date_to_write, '(A,A)') date_to_write(1:11), ', '
      write(date_to_write, '(A,A)')date_to_write(1:13),a_date(1:4)//'\r'
 567  if(a_date(6:7).eq.'10') goto 568
      goto 569
 568  date_to_write = 'October '
      write(date_to_write, '(A,I1)') date_to_write(1:8),i
      write(date_to_write, '(A,A)') date_to_write(1:9), ', '
      write(date_to_write, '(A,A)')date_to_write(1:11),a_date(1:4)//'\r'
 569  if(a_date(6:7).eq.'11') goto 570
      goto 571
 570  date_to_write = 'November '
      write(date_to_write, '(A,I1)') date_to_write(1:9),i
      write(date_to_write, '(A,A)') date_to_write(1:10), ', '
      write(date_to_write, '(A,A)')date_to_write(1:12),a_date(1:4)//'\r'
 571  if(a_date(6:7).eq.'12') goto 572
      goto 523
 572  date_to_write = 'December '
      write(date_to_write, '(A,I1)') date_to_write(1:9),i
      write(date_to_write, '(A,A)') date_to_write(1:10), ', '
      write(date_to_write, '(A,A)')date_to_write(1:12),a_date(1:4)//'\r'

 523  date_to_write = 'Date: '//date_to_write(1:30)
      write(4,'(A)') date_to_write
      return
      end


      subroutine fill_attendance_arr(arr,fs_a,i)
* subroutine to create an array and fill with attendance records
      character*26 dummy
      integer i,fs_a,a_id
      character*6 a_l
      character*16 a_e_date
      character*26 arr(1000)

      call r_attendance_f(a_id,a_l,a_e_date,fs_a)
* read a record form attendance file
      write(dummy,'(I4,A,A)') a_id,a_l,a_e_date
      i = 1
 100  if(fs_a.eq.0) go to 101
      go to 102
 101  arr(i) = dummy
      call r_attendance_f(a_id,a_l,a_e_date,fs_a)
      write(dummy,'(I4,A,A)') a_id,a_l,a_e_date
      i = i+1
      go to 100
 102  call c_attendance_f()
      return
      end

      subroutine sort_arr(arr,arr_size)
* subroutine to sort the array consisting of attendance records
      integer i,j,arr_size
      character*26 arr(1000), tmp
      i = 1
 300  if(i.ge.arr_size - 1) goto 304
      j = 1
 301  if(j.ge.arr_size - 1) goto 303
      if(arr(j) .le. arr(j+1)) goto 302
      tmp = arr(j)
      arr(j) = arr(j+1)
      arr(j+1) = tmp
 302  j = j + 1
      goto 301
 303  i = i + 1
      go to 300
 304  return
      end

      subroutine r_a_date(a_date,fs)
* read date form attendance file
      character*10 a_date
      integer fs
      read(1,'(A10)', iostat=fs) a_date
      return
      end

      subroutine r_m_date(m_date)
* read date from monthly attendance
      character*10 m_date
      call o_attendance_f()
      read(1,'(A)') m_date
      call c_attendance_f()
      return
      end

      subroutine o_attendance_f()
      open(unit=1,file='attendance.txt',status='old')
      return
      end

      subroutine r_attendance_f(staff_id_x,a_l_x,a_date_x,fs)
* read a record from attendance file
      character*26 i
      character*6 a_l_x
      character*16 a_date_x
      integer staff_id_x,fs
      read(1, '(A26)',iostat=fs) i
      if(fs.eq.0) go to 200
      go to 201
 200  read(i(1:4),'(I4)') staff_id_x
      a_l_x = i(5:10)
      a_date_x = i(11:26)
 201  return
      end


      subroutine c_attendance_f()
      close(1)
      return
      end

      subroutine o_employees_f()
      open(unit=2,file='employees.txt',status='old')
      return
      end

      subroutine r_employees_f(e_id,fname,lname,dept,fs)
* read a record from employees file
      integer fs, e_id
      character*64 s
      character*20 fname
      character*10 lname
      character*3 dept
      read(2,'(A)',iostat=fs) s
      if(fs .ne. 00 ) goto 800
      read(s(1:4), '(I4)') e_id
      read(s(5:14), '(A)') lname
      read(s(15:34), '(A)') fname
      read(s(56:58), '(A)') dept
 800  return
      end

      subroutine c_employees_f()
      close(2)
      return
      end

      subroutine o_summary_f()
      open(unit=4,file='summaryfor.txt')
      return
      end

      subroutine c_summary_f()
      close(4)
      return
      end

      subroutine o_m_attendance_f()
      open(unit=7,file='monthly-attendancefor.txt')
      return
      end

      subroutine w_m_date(m_date)
* write monthly date
      character*10 m_date
      write(7,'(A,A)') m_date(1:7),'\r'
      return
      end

      subroutine w_m_record(s_id, absent,quarter,overtime)
* write records into monthly attendance file
      integer s_id, absent, quarter,overtime
      if(overtime .gt. 30) goto 777
      goto 778
 777  overtime = 30
 778  write(7,'(I4,I3.3,I3.3,I3.3,A)') s_id,absent,quarter,overtime,'\r'
      return
      end

      subroutine algo_m_attendance(s_id,absent,quarter,overtime,day)
      integer s_id, absent, quarter, overtime, a,q,o
      character*2 day


      if(day .ne. '01') goto 900
      a = 000
      q = 000
      o = 000
      goto 901

 900  call r_attendance_record(s_id,a,q,o)
 901  a = a + absent
      q = q + quarter
      o = o + overtime
      call w_m_record(s_id, a,q,o)
      return
      end

      subroutine o_r_attendance_f()
      open(unit=8,file='monthly-attendance.txt')
      return
      end

      subroutine c_r_attendance_f()
      close(8)
      return
      end

      subroutine r_attendance_record(s_id,a,q,o)
* read records from attendance file
      integer s_id,a,q,o,io
      character*13 s
      if(io .eq. 0) goto 904
      goto 903
 904  read(8, '(A)',iostat=io) s
      if(s(5:5) .ne. '-') goto 902
      read(8, '(A)') s
 902  read(s(1:4), '(I4)') s_id
      read(s(5:7), '(I4)') a
      read(s(8:10), '(I4)') q
      read(s(11:13), '(I4)') o
 903  return
      end

