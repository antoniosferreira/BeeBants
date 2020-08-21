const functions = require('firebase-functions');
const admin = require('firebase-admin');
const path = require('path');
const os = require('os');
const fs = require('fs');

admin.initializeApp();


 
exports.getManchesterBarsSuggestionList = functions.https.onRequest(
	(request, response) => {
		
		encodedProfile = request.get('encodedProfile')	
		userLocation = request.get('userLocation')
		userOption = request.get('userOption')

		
		const bucket = admin.storage().bucket();
		let fileName = 'Manchester/BarsProfiled/' + encodedProfile + '.json'
		const tempFilePath = path.join(os.tmpdir(), fileName);
		
		bucket.file(fileName).download({destination: tempFilePath});

		let rawdata = fs.readFileSync(tempFilePath);
		let student = JSON.parse(rawdata);
		
		return student
	})
