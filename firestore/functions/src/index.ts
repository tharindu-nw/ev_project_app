import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp()

const db = admin.firestore()

//this function will run when the user is created from the app. A user document will be created for the user
export const onUserCreate = functions.auth.user().onCreate(user => {
    const userObject = {    //getting the user details from auth user object
        name: user.displayName,   
        email: user.email,        
        emailVerified : user.emailVerified
    }
    return db.doc('users/' + user.uid).set(userObject)    //create the doc and set the details
})

//TODO: Function for starting a trip
//TODO: Function for finishing the trip