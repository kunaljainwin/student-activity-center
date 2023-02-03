// importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
// importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");



// const firebaseConfig = {
//     apiKey: "AIzaSyAWT3g73HTwiePpKXDywTs3z4_--2_C0zU",
//     authDomain: "visitcounter-fef16.firebaseapp.com",
//     databaseURL: "https://visitcounter-fef16-default-rtdb.firebaseio.com",
//     projectId: "visitcounter-fef16",
//     storageBucket: "visitcounter-fef16.appspot.com",
//     messagingSenderId: "684329885216",
//     appId: "1:684329885216:web:fe77d493c10d3eaa032645",
//     measurementId: "G-WNB3QKWVJ2"
//   };
//  firebase.initializeApp(firebaseConfig);
// const messaging = firebase.messaging();
// // if('serviceWorker' in navigator) { 
// //   navigator.serviceWorker.register('../firebase-messaging-sw.js')
// // .then(function(registration) {
// //  console.log("Service Worker Registered");
// // messaging.useServiceWorker(registration);  
// //   }); 
// //   }
// // messaging.setBackgroundMessageHandler(function (payload) {
// //     const promiseChain = clients

// //         .matchAll({
// //             type: "window",
// //             includeUncontrolled: true
// //         })
// //         .then(windowClients => {
// //             for (let i = 0; i < windowClients.length; i++) {
// //                 const windowClient = windowClients[i];
// //                 windowClient.postMessage(payload);
// //             }
// //         })
// //         .then(() => {
// //             return registration.showNotification("New Message");
// //         });
// //     return promiseChain;
// // });
// // // self.addEventListener('notificationclick', function (event) {
// // //     console.log('notification received: ', event)
// // // });