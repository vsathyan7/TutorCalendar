var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var debug_level = 1
var sqlite3 = require("sqlite3").verbose();
var total_days = 42

var mysql      = require('mysql');

function debug(){
    if (debug_level >= arguments[0]){
        var str = ""
        if (arguments.length > 2) {
        for (var i = 1; i < arguments.length; i++) {
            str += arguments[i] + " "
        }
        console.log(str)
        }
        else {
            console.log(arguments[1])
        }
    }
 
}
function parseDate(s) {
    //    var months = {jan:0,feb:1,mar:2,apr:3,may:4,jun:5,
    //                jul:6,aug:7,sep:8,oct:9,nov:10,dec:11};

    var p = s.split('-');
    //    debug(2,p, Date(p[0] + "-" + p[1] + "-" + p[2]))
    return new Date(p[0] + "-" + p[1] + "-" + p[2]);
}

function unparseDate(dd) {
    var d = new Date(dd)

    var ds = d.getUTCFullYear() + "-" + (("0" + (d.getUTCMonth() + 1)).slice(-2)) + "-" + (("0" + d.getUTCDate()).slice(-2));
    return (ds)
}

function unparseTime(dd) {
    var d = new Date(dd)
    var ts = ("0" + d.getUTCHours()).slice(-2) + ":" + ("0" + d.getUTCMinutes()).slice(-2)
    return (ts)
}

function localDateTime(d){
    var s = d.getFullYear() + "-" + (("0" + (d.getMonth() + 1)).slice(-2)) + "-" + (("0" + d.getDate()).slice(-2)) +
        "T" + ("0" + d.getHours()).slice(-2) + ":" + ("0" + d.getMinutes()).slice(-2) + ":00"
    return (s)
}

function UpsertStudents(res, student_id, tutor, name, email, subject_1, subject_2, subject_3, 
                         subject_1_rating, subject_2_rating, subject_3_rating) {
    var db = openDB()
    debug(1, "Upsert Students - Student ID", student_id, tutor, name, email, subject_1, subject_2, subject_1_rating, subject_2_rating, subject_3_rating)
    if (student_id == null) {
        var insert_stmt = "INSERT IGNORE INTO students (tutor, name, email, " +
                      "subject_1, subject_2, subject_3, subject_1_rating, subject_2_rating, subject_3_rating) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        db.query({
          sql: insert_stmt,
          values: [tutor, name, email, subject_1, subject_2, subject_3,
                  subject_1_rating, subject_2_rating, subject_3_rating]
        }, function (error, result) {
            debug(1, "insert stmt", insert_stmt, error, result.insertId)
            var jsonResponse = {studentID: result.insertId}
            debug(1, jsonResponse)
            return res.json(jsonResponse)
        });
        
    }
    else {
        var update_stmt = "UPDATE  IGNORE students SET student_id = ?, tutor = ?, name = ?, email = ?, " +
                          "subject_1 = ?, subject_2 = ?, subject_3 = ?, " +
                          "subject_1_rating = ?, subject_2_rating = ?, subject_3_rating = ? " +
                          "where student_id = ?"

        db.query({
          sql: update_stmt,
          values: [student_id, tutor, name, email, subject_1, subject_2, subject_3,
                  subject_1_rating, subject_2_rating, subject_3_rating, student_id]
        }, function (error) {
            debug(2, "update stmt", update_stmt, error)
        });
    
        var insert_stmt = "INSERT IGNORE INTO students (student_id, tutor, name, email, " +
                      "subject_1, subject_2, subject_3, subject_1_rating, subject_2_rating, subject_3_rating) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        db.query({
          sql: insert_stmt,
          values: [student_id, tutor, name, email, subject_1, subject_2, subject_3,
                  subject_1_rating, subject_2_rating, subject_3_rating]
        }, function (error, result) {
            debug(1, "insert stmt", insert_stmt, error, result)
        });
    }

    closeDB(db)
}

function UpsertAppt(res, appointment_id, student_id, pfaculty_id, schedule_date, title, notes, location, subject, faculty_name, time_block) {
    var db = openDB()
    debug(1, "Upsert Appt", time_block, schedule_date, student_id, appointment_id)
    var faculty_id = parseInt(pfaculty_id)
    var update_stmt = "UPDATE IGNORE appointments SET student_id = ?, faculty_id = ?, schedule_date = ?, title = ?, notes = ?, location = ?, subject = ?, time_block = ? where appointment_id = ?"
    if (appointment_id > 0) {
    db.query({
      sql: update_stmt,
      values: [student_id, faculty_id, schedule_date, title, notes, location, subject, time_block, appointment_id]
    }, function (error) {
        debug(2, "update stmt", update_stmt, error)
    });
    }
    
    var insert_stmt = "INSERT IGNORE INTO appointments (student_id, faculty_id, schedule_date, title, notes, location, subject, time_block) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"

    db.query({
      sql: insert_stmt,
      values: [student_id, faculty_id, schedule_date, title, notes, location, subject, time_block]
    }, function (error) {
        debug(2, "insert stmt", insert_stmt, error)
    });
    closeDB(db)
    if (res != null) {
        res.json({"processed": true})
    }                
}

function DeleteAppt(res, appointment_id) {
    var db = openDB()
    debug(1, "DeleteAppt")
    var delete_stmt = "DELETE FROM appointments WHERE appointment_id = ?"
    db.query({
        sql: delete_stmt,
        values: [appointment_id]
    }, function(error){
        debug(1, error, delete_stmt)
    });
    closeDB(db)
    if (res != null) {
        res.json({"processed": true})
    }                    
}

function UpsertDay(student_id, schedule_date, morning_busy, afternoon_busy, evening_busy) {
    var vmorning_busy = 0
    var vevening_busy = 0
    var vafternoon_busy = 0
    var db = openDB()
    var update_stmt = "UPDATE IGNORE day_summary SET student_id = ?, schedule_date = ?, morning_busy = ?, afternoon_busy = ?, evening_busy = ? where student_id = ? and schedule_date = ?"
    db.query({
      sql: update_stmt,
      values: [student_id, schedule_date, morning_busy, afternoon_busy, evening_busy, student_id, schedule_date]
    }, function (error) {
        debug(2, "update stmt", update_stmt, error)
    });
    
    var insert_stmt = "INSERT IGNORE INTO day_summary (student_id, schedule_date, morning_busy, afternoon_busy, evening_busy) VALUES (?, ?, ?, ?, ?)"

    db.query({
      sql: insert_stmt,
      values: [student_id, schedule_date, morning_busy, afternoon_busy, evening_busy]
    }, function (error) {
        debug(2, "insert stmt", insert_stmt, error)
    });
    closeDB(db)
    
}

function SelectDays(student_id, start_date_string, days, req, res) {
    var selectDaysStmt = 
        "SELECT date(apt.schedule_date) as schedule_date, "
        + "count(morning.student_id) as morning_busy, "
        + "count(afternoon.student_id) as afternoon_busy, "
        + "count(evening.student_id) as evening_busy "
        + "FROM appointments apt "
        + "left join appointments morning on (apt.appointment_id = morning.appointment_id and "
        + "morning.time_block = 'morning') "
        + "left join appointments afternoon on (apt.appointment_id = afternoon.appointment_id and "
        + "afternoon.time_block = 'afternoon') "
        + "left join appointments evening on (apt.appointment_id = evening.appointment_id and "
        + "evening.time_block = 'evening') "
        + "where (apt.student_id = ? or apt.faculty_id = ?) "
        + "and date(apt.schedule_date) >= ? and date(apt.schedule_date) <= ? "
        + "group by date(apt.schedule_date)"

        var DaysToReturn = []

        var start_date = parseDate(start_date_string)
        var end_date = parseDate(start_date_string)
        var run_date = parseDate(start_date_string)

        end_date.setDate(end_date.getDate() + days)

        var end_date_string = unparseDate(end_date)

        start_date_string = unparseDate(start_date)
        
        var run_date_string
        for (var i = 0; i < days; i++) {
            run_date_string = unparseDate(run_date)
            DaysToReturn.push({
                schedule_date: run_date_string,
                morning_busy: 0,
                afternoon_busy: 0,
                evening_busy: 0
            })
            run_date.setDate(run_date.getDate() + 1)
        }
        debug(2, "stme param in Select Days", student_id, start_date_string, end_date_string)
        var current_counter_day = 0
        var db = openDB()

        db.query({
            sql: selectDaysStmt,
            values: [student_id, student_id, start_date_string, end_date_string]
        }, function(err, results, fields){
           debug(2, err)
           var start_counter = 0
           for (var i = 0; i < results.length; i++){
               for (j = start_counter; j < total_days; j++){
               debug(2, start_counter, DaysToReturn[j].schedule_date, unparseDate(results[i].schedule_date))
               if (DaysToReturn[j].schedule_date == unparseDate(results[i].schedule_date)) {
                   DaysToReturn[j].morning_busy = results[i].morning_busy
                   DaysToReturn[j].afternoon_busy = results[i].afternoon_busy
                   DaysToReturn[j].evening_busy = results[i].evening_busy
                   start_counter = j
                   break
               }
               }
           }
           debug(2, fields)
//           return (DaysToReturn)
           closeDB(db)
            res.json(DaysToReturn)
        });
}

function SelectAppts(student_id, appt_date_string, req, res) {

        var ApptsToReturn = []

        var appt_date = parseDate(appt_date_string)

            debug(2,"Select Appointments")
            debug(2, appt_date_string)
        appt_date_string = unparseDate(appt_date)
            debug(2, appt_date_string)

        var stmt = 
            "SELECT appointment_id"
           +", appt.student_id " 
	       +", stu.name as student_name "
           +", appt.faculty_id "
           +", fac.name as faculty_name "
           +", appt.schedule_date "
           +", appt.title "
           +", appt.notes "
           +", appt.location "
           +", appt.subject  "
           +", appt.time_block "
           +"FROM appointments appt "
           +", students stu "
           +", students fac  "
           +"where (appt.student_id = ? or appt.faculty_id = ?)  "
	       +"and date(appt.schedule_date) = ?  "
           +"and stu.student_id = appt.student_id  "
           +"and fac.student_id = appt.faculty_id "
            var db = openDB()
        db.query({
            sql: stmt, 
            values: [student_id, student_id, appt_date_string]
        }, function (err, results, fields) {
                
            debug(1,"Select Appointments DB Each")
            debug(1, err)
            debug(2,results)
            for (var i = 0; i < results.length; i++){
                ApptsToReturn.push({
                    appointmentID: results[i].appointment_id,
                    studentID: results[i].student_id,
                    studentName: results[i].student_name,
                    facultyID: results[i].faculty_id,
                    facultyName: results[i].faculty_name,
                    title: results[i].title,
                    scheduleDateTime: localDateTime(results[i].schedule_date),
                    notes: results[i].notes,
                    location: results[i].location,
                    subject: results[i].subject,
                    timeBlock: results[i].time_block
                })
                debug(1, ApptsToReturn[i])
            }

            closeDB(db)
            res.json(ApptsToReturn)
//            
//            var dt = parseDate(row.schedule_date)
//            var ds = unparseTime(dt)
//
//            ApptsToReturn.push({
//                    studentID: row.student_id,
//                    studentName: row.student_name,
//                    facultyID: row.faculty_id,
//                    facultyName: row.faculty_name,
//                    scheduleDateTime: row.schedule_date,
//                    scheduleDate: unparseDate(row.schedule_date),
//                    scheduleTime: unparseTime(row.schedule_date),
//                    title: row.title,
//                    notes: row.notes,
//                    location: row.location,
//                    subject: row.subject,
//                    role: (row.student_id == student_id) ? "Student" : "Faculty"
//            })
        });
}

function SelectStudents(student_id, req, res) {


        var StudentsToReturn = []

        var stmt = "SELECT student_id, name as student_name, email, subject_1, subject_2, subject_3 FROM students where student_id = ?"

        if (student_id == 0) {
            stmt = "SELECT student_id, name as student_name, email, subject_1, subject_2, subject_3, ? FROM students"
        }
        debug(2,"Select Students")

        db = openDB()
    db.query({
      sql: stmt,
      values: [student_id]
    }, function (error, results, fields) {
        debug(2, "insert stmt", stmt, error)
    
                //            debug(2,row)
            for (var i = 0; i < results.length; i++){
        debug(2, results[i])
                StudentsToReturn.push({
                    studentID: results[i].student_id,
                    studentName: results[i].student_name,
                    email: results[i].email,
                    subject_1: results[i].subject_1,
                    subject_2: results[i].subject_2,
                    subject_3: results[i].subject_3
                })}
        res.json(StudentsToReturn)
        closeDB(db)
        
            });
}

function openDB(){
    var db = mysql.createConnection({
      host     : 'localhost',
      user     : 'tutor',
      password : 'tutor',
      database : 'tutor'
    });
    db.connect();
    return db
}

function closeDB(db){
    db.end()
}
function createDB() {

    var student_ddl = "CREATE TABLE IF NOT EXISTS students (student_id Integer AUTO_INCREMENT primary key, " +
        "tutor boolean, name text, email text, " +
        "subject_1 text, subject_2 text, subject_3 text, " +
        "subject_1_rating Integer, subject_2_rating Integer, subject_3_rating Integer " +
        ")"
    
    var appt_ddl = "CREATE TABLE IF NOT EXISTS appointments (appointment_id integer AUTO_INCREMENT primary key, student_id integer, faculty_id integer, schedule_date DATETIME, title text, notes text, location text, subject text, time_block text, constraint appt_ukey unique (student_id, faculty_id, schedule_date))"
    
    var days_ddl = "CREATE TABLE IF NOT EXISTS day_summary (day_summary_id integer AUTO_INCREMENT primary key, student_id integer, schedule_date DATETIME, morning_busy boolean, afternoon_busy boolean, evening_busy boolean, constraint day_ukey unique (student_id, schedule_date))"
    
    var db = openDB()
    
    db.query({
      sql: student_ddl
    }, function (error) {
        debug(2, "student ddl", error)
    });

    db.query({
      sql: appt_ddl
    }, function (error) {
        debug(2, "appt ddl", error)
    });

    db.query({
      sql: days_ddl
    }, function (error) {
        debug(2, "days ddl", error)
    });
    closeDB(db)
    
        UpsertAppt(null, 1, 3, "2016-12-01T11:15:00.000Z", "Navigation Controller", "Notes - 2", "Singapore", "CIS-57", "DeAnza Lab", "morning")
        
        UpsertAppt(null, 1, 2, "2016-12-02T12:12:00.000Z", "Segue Help", "Notes - 1", "Singapore", "CIS-55", "DeAnza Lab", "morning")
        UpsertAppt(null, 1, 4, "2016-12-02T16:16:00.000Z", "Sorting - Tables", "Notes - 7", "Singapore", "CIS-52", "DeAnza Lab", "afternoon")
        UpsertAppt(null, 1, 3, "2016-12-02T18:18:00.000Z", "Image Upload", "Notes - 7", "Singapore", "CIS-50", "DeAnza Lab", "evening")
        UpsertAppt(null, 2, 4, "2016-12-02T18:05:00.000Z", "Another Image Upload", "Notes - 7", "Singapore", "CIS-50", "DeAnza Lab", "evening")

        UpsertAppt(null, 1, 4, "2016-12-03T10:50:00.000Z", "Table Sections", "Notes - 3", "Singapore", "CIS-59", "DeAnza Lab", "afternoon")
        
        UpsertAppt(null, 1, 3, "2016-12-05T14:00:00.000Z", "Core Data", "Notes - 4", "Singapore", "CIS-56", "DeAnza Lab", "evening")
        
        UpsertAppt(null, 1, 2, "2016-12-07T15:06:00.000Z", "Thanksgiving Turkey", "Notes - 6", "Singapore", "CIS-58", "DeAnza Lab", "morning")

        
        UpsertStudents(null, 1, 0, "Dinesh", "Dinesh@fhda.edu", "", "", "", 1, 2, 3);
        UpsertStudents(null, 2, 1, "Sathya", "Sathya@fhda.edu", "CS-55", "CS-66", "", 1, 2, 4);
        UpsertStudents(null, 3, 0, "Quan", "Quan@fhda.edu", "", "", "", 2, 3, 4);
        UpsertStudents(null, 4, 1, "Jyothsana", "Jyothsna@fhda.edu", "CS-66", "", "", 3, 2, 5);

    
        UpsertDay(1, "2016-11-13", 0, 0, 1);
        UpsertDay(1, "2016-11-14", 0, 1, 1);
        UpsertDay(1, "2016-11-15", 0, 0, 1);
        UpsertDay(1, "2016-11-16", 0, 0, 1);
        UpsertDay(1, "2016-11-17", 0, 1, 1);
        UpsertDay(1, "2016-11-18", 0, 0, 1);
        UpsertDay(1, "2016-11-20", 0, 1, 1);
        UpsertDay(1, "2016-11-21", 0, 1, 1);
        UpsertDay(1, "2016-11-22", 0, 1, 1);
        UpsertDay(1, "2016-11-24", 0, 0, 0);
        UpsertDay(1, "2016-11-26", 0, 1, 0);
        UpsertDay(1, "2016-11-28", 0, 0, 1);
        UpsertDay(1, "2016-11-29", 0, 1, 0);
        UpsertDay(1, "2016-11-30", 0, 0, 1);
        UpsertDay(1, "2016-12-01", 0, 0, 1);
        UpsertDay(1, "2016-12-07", 0, 0, 1);

    return
    

}

createDB()
//closeDB(db)

app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

app.get('/', function (req, res) {
    //  res.json(days);
    debug(2, req.params)
    SelectDays(1, '2016-10-30', total_days, req, res)
});

app.get('/student/studentID/:studentID', function (req, res) {
    //    debug(2,req.body)
    SelectStudents(parseInt(req.params.studentID), req, res)
});

app.get('/date/:date/studentID/:studentID', function (req, res) {
    SelectDays(req.params.studentID, req.params.date, total_days, req, res)
});

app.get('/appt/date/:date/studentID/:studentID', function (req, res) {
    SelectAppts(req.params.studentID, req.params.date, req, res)
});


app.get('/image/studentID/:studentID', function (req, res) {
    res.sendFile(__dirname + "/image/" + req.params.studentID +".png");
});

app.post('/createAppt', function (req, res) {
    debug(1,"createAppt")
    debug(1,req.body)
    var jsDate = req.body.scheduleDateTime.substring(0, 10) + "T" + req.body.scheduleDateTime.substring(11) + ".000Z"
        //    debug(2,jsDate)
    UpsertAppt(res, parseInt(req.body.appointmentID), parseInt(req.body.studentID), parseInt(req.body.facultyID), req.body.scheduleDateTime, req.body.title, req.body.details, req.body.location, req.body.subject, req.body.facultyName, req.body.timeBlock)
//    res.json(true);
});

app.post('/createStudent', function (req, res) {
    debug(1,"createStudent")
    debug(1,req.body)
    
    
    UpsertStudents(res, null, req.body.tutor == "0", 
                   req.body.studentName, req.body.studentEmail, 
                   req.body.subject1, req.body.subject2, req.body.subject3,
                   parseInt(req.body.subject1Rating), parseInt(req.body.subject2Rating), 
                   parseInt(req.body.subject3Rating))
    
//    res.json(true);
});


app.delete('/deleteAppt', function (req, res) {
    debug(1,"deleteAppt")
    debug(1,req.body)
    DeleteAppt(res, parseInt(req.body.appointmentID))
//    res.json(true);
});
app.listen(process.env.PORT || 8000);