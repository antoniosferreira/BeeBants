import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


admin.initializeApp()

// Reads Profiling Information
export const readProfilings = functions.https.onCall( async (data, context) => {
	
	if (context.auth) {
		
		const uid = context.auth.uid
	
		let userName = null
		let profileBar = null
		let profileRestaurant = null
		
		
		await admin.firestore().collection("Users").doc(uid).get().then(
			
		snapshot => {
				userName = snapshot?.data()?.name
		}).catch(reason => {
			console.log('Error getting user profile name on user ' + uid);
			throw new functions.https.HttpsError("aborted", "Failed retrieving user name profile");}
		)
	
	
	
		await admin.firestore().collection("ProfilingBars").doc(uid).get().then(
			
		snapshot => {
		
				profileBar = {
					"price": snapshot?.data()?.price,
					"style1": snapshot?.data()?.style1,
					"style2": snapshot?.data()?.style2,
					"style3": snapshot?.data()?.style3,
					"density1": snapshot?.data()?.density1,
					"density2": snapshot?.data()?.density2,
					"density3": snapshot?.data()?.density3,
					"time1": snapshot?.data()?.time1,
					"time2": snapshot?.data()?.time2
				}
				
		}).catch(reason => {
			console.log('Error getting bars profiling on user ' + uid);
			throw new functions.https.HttpsError("aborted", "Failed retrieving bar profile");}
		)
		
		
		
		await admin.firestore().collection("ProfilingRestaurants").doc(uid).get().then(
			
		snapshot => {
			
				profileRestaurant = {
					"price": snapshot?.data()?.price,
					"amb1": snapshot?.data()?.amb1,
					"amb2": snapshot?.data()?.amb2,
					"amb3": snapshot?.data()?.amb3,
					"diet1": snapshot?.data()?.diet1,
					"diet2": snapshot?.data()?.diet2,
					"diet3": snapshot?.data()?.diet3,
					"diet4": snapshot?.data()?.diet4
				}
			
		}).catch(reason => {
			console.log('Error getting res profiling on user ' + uid);
			throw new functions.https.HttpsError("aborted", "Failed retrieving res profile");}
		)
		
		
		
		
		// returns 
		return {
			userName : userName,
			profileBar : profileBar,
			profileRestaurant : profileRestaurant
		};
	}
	
	throw new functions.https.HttpsError("unauthenticated", "User not authenticated");
	
});


// Stores a Trip Event
export const storeTripData = functions.https.onCall( async (data, context) => {
   
	if (context.auth) {
		
		const uid = context.auth.uid
		
		const tripData = {
			cityName: data.cityName,
			spotName: data.spotName,
			locImg: data.locImg,
			timestamp: admin.firestore.Timestamp.now(),
			review : 0
		};
		
		const tripDoc = await admin.firestore().collection('History').add(tripData);
		
		const userRef = admin.firestore().collection('Users').doc(uid);
		
		await userRef.update({history: admin.firestore.FieldValue.arrayUnion(tripDoc.id)});
		
		// returns 
		return {
			tripRef : tripDoc.id
		};
	}
	
	throw new functions.https.HttpsError("unauthenticated", "User not authenticated");
	
});


// Updates a Bar Profile for given user
export const updateBarProfile = functions.https.onCall( async (data, context) => {
	
	if (context.auth) {
		
		const uid = context.auth.uid
		
		
		// VALIDATES NEW PROFILE
		if (!(data.price === 0 || data.price === 1 || data.price === 2)) {
			throw new functions.https.HttpsError("cancelled", "Make sure you select at least one price option");
		}
		
		if (data.style1 === 0 && data.style2 === 0 && data.style3 === 0) {
			throw new functions.https.HttpsError("cancelled", "Make sure you select at least one style option");
		}
		
		if (data.density1 === 0 && data.density2 === 0 && data.density3 === 0) {
			throw new functions.https.HttpsError("cancelled", "Make sure you select at least one density option");
		}
		
		if (data.time1 === 0 && data.time2 === 0) {
			throw new functions.https.HttpsError("cancelled", "Make sure you select at least one time option");
		}
		
		
		// CALCULATES ENCODED PROFILE
		let encoded = "" + data.price
		encoded = encoded + (data.style1 ? 1 : 0)
		encoded = encoded + (data.style2 ? 1 : 0)
		encoded = encoded + (data.style3 ? 1 : 0)
		encoded = encoded + (data.density1 ? 1 : 0)
		encoded = encoded + (data.density2 ? 1 : 0)
		encoded = encoded + (data.density3 ? 1 : 0)
		
		encoded = encoded + (data.time1 ? 1 : 0)
		encoded = encoded + (data.time2 ? 1 : 0)
		
		
		// UPDATES USER DOCUMENT
		const newProfile = {
			price: data.price,
			style1: data.style1,
			style2: data.style2,
			style3: data.style3,
			density1: data.density1,
			density2: data.density2,
			density3: data.density3,
			time1: data.time1,
			time2: data.time2,
			encodedProfile: encoded
		}
		
		await admin.firestore().collection('ProfilingBars').doc(uid).update(newProfile);
		
		return 
	}
	
	throw new functions.https.HttpsError("unauthenticated", "User not authenticated");
});




// Updates a Res Profile for given user
export const updateResProfile = functions.https.onCall( async (data, context) => {
	
	if (context.auth) {
		
		const uid = context.auth.uid
		
		
		// VALIDATES NEW PROFILE
		if (!(data.price === 0 || data.price === 1 || data.price === 2)) {
			throw new functions.https.HttpsError("cancelled", "Make sure you select at least one price option");
		}
		
		if (data.amb1 === 0 && data.amb2 === 0 && data.amb3 === 0) {
			throw new functions.https.HttpsError("cancelled", "Make sure you select at least one ambiance option");
		}
				
		// CALCULATES ENCODED PROFILE
		let encoded = "" + data.price
		encoded = encoded + (data.diet1 ? 1 : 0)
		encoded = encoded + (data.diet2 ? 1 : 0)
		encoded = encoded + (data.diet3 ? 1 : 0)
		encoded = encoded + (data.diet4 ? 1 : 0)
		encoded = encoded + (data.amb1 ? 1 : 0)
		encoded = encoded + (data.amb2 ? 1 : 0)
		encoded = encoded + (data.amb3 ? 1 : 0)
		
		// UPDATES USER DOCUMENT
		const newProfile = {
			price: data.price,
			diet1: data.diet1,
			diet2: data.diet2,
			diet3: data.diet3,
			diet4: data.diet4,
			amb1: data.amb1,
			amb2: data.amb2,
			amb3: data.amb3,
			encodedProfile: encoded
			
		}
		
		await admin.firestore().collection('ProfilingRestaurants').doc(uid).update(newProfile);
		
		return 
	}
	
	throw new functions.https.HttpsError("unauthenticated", "User not authenticated");
	
});


// Loads more 5 history trips to user
export const loadHistory = functions.https.onCall( async (data, context) => {
	
	let historyResult = null
	
	if (context.auth) {
		
		const uid = context.auth.uid
				
		
		await admin.firestore().collection("Users").doc(uid).get().then(
			
		snapshot => {
			
			const history = (snapshot?.data()?.history).reverse()
			
			
			if (history.length < 5) {
				historyResult = history
				
			} else {
				
				
				if ((5*data.offset + 4) > history.slice(5*data.offset,history.length)) {
					historyResult = history.slice(5*data.offset, history.legth)
				} else {
					historyResult = history.slice(5*data.offset, 5*data.offset + 4)
				}
				
			}
			
		}).catch(reason => {
			console.log('Error getting user profile on user ' + uid);
			throw new functions.https.HttpsError("aborted", "Failed retrieving user profile");}
		)
	} else {
		throw new functions.https.HttpsError("unauthenticated", "User not authenticated");
	}
	
	return {
		historyElements: historyResult,
		test: "here"
	};
});


// Create default profile when signing up
exports.initProfile = functions.firestore
		.document('Users/{userId}')
		.onCreate(async (snap, context) => {
			const username = snap.data().name;
			
			
			const barProfileDefault = {
				density1 : true,
				density2: true,
				density3: true,
				style1: true,
				style2: true,
				style3: true,
				time1: true, 
				time2: true,
				price: 2,
				name: username,
				encodedProfile: "211111111",
				uid: context.params.userId,
				version: 0
			};
			
			await admin.firestore().doc(`/ProfilingBars/${context.params.userId}`).set(barProfileDefault);			
			
			
			const resProfileDefault = {
				amb1 : true,
				amb2: true,
				amb3: true,
				diet1: false,
				diet2: false,
				diet3: false,
				diet4: false, 
				price: 2,
				name: username,
				encodedProfile: "21110000",
				uid: context.params.userId,
				version: 0
			};
			
			await admin.firestore().doc(`/ProfilingRestaurants/${context.params.userId}`).set(resProfileDefault);	

		
		
		});

