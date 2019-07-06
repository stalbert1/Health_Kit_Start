import UIKit

struct Exercise {
    var name: String
    var minutes: Int
}

let myExercise1 = Exercise(name: "weight lifting", minutes: 30)
let myExercise2 = Exercise(name: "weight lifting", minutes: 30)
let myExercise3 = Exercise(name: "curling", minutes: 120)
let myExercise4 = Exercise(name: "weight lifting", minutes: 30)
let myExercise5 = Exercise(name: "weight lifting", minutes: 30)
let myExercise6 = Exercise(name: "curling", minutes: 120)
let myExercise7 = Exercise(name: "weight lifting", minutes: 30)
let myExercise8 = Exercise(name: "weight lifting", minutes: 30)
let myExercise9 = Exercise(name: "tennis", minutes: 60)
let myExercise10 = Exercise(name: "weight lifting", minutes: 30)
let myExercise11 = Exercise(name: "tennis", minutes: 60)

//weight lifting = 210
//curling = 240
//tennis = 120

let myExercises = [myExercise1, myExercise2, myExercise3, myExercise4, myExercise5, myExercise6, myExercise7, myExercise8, myExercise9, myExercise10, myExercise11]

//will have a dictionary of keys as string and int to keep the totals.
var totalMinutesPerExercise = [String : Int]()

//next loop through all array and build the dictionary adding as you go...
for exercise in myExercises {
    
    if totalMinutesPerExercise[exercise.name] == nil {
        totalMinutesPerExercise[exercise.name] = exercise.minutes
    } else {
        totalMinutesPerExercise[exercise.name] = totalMinutesPerExercise[exercise.name]! + exercise.minutes
    }
    
}

print(totalMinutesPerExercise)

