### Inspiration
As college students, we're all too aware that uncomfortable and threatening social interactions unfold around us every day. Whether it be sexual harassment at parties or aggressive confrontations due to social drama, we believe that said interactions are best resolved through intervention by the close friends of those involved.

### What it does
Our app provides a discrete way for users to send an alert to friends, asking for support without having to text individuals and guess who may be nearby. Anyone who is friends with the person in distress will receive a notification with a name, timestamp, and location of the alert. They can then use this information to respond to their friend's signal if possible. Check out the [Devpost](https://devpost.com/software/beacon-aqdfic) to see an app demo, screenshots, and more!

### How we built it
We used SwiftUI in XCode to build an IOS application, and used Firebase/Firestore to host the data for users and alerts online.

### Challenges we ran into
We faced many challenges throughout the hackathon, most notably the fact that none of us had used SwiftUI before. We also struggled with using IOS functions like location and notifications due to the permissions requirements that we were not familiar with.

### Accomplishments that we're proud of
Managing to create a functional IOS app with no prior experience in Swift was a major accomplishment on its own. We are also proud of our efficient use of Firestore to create a fully functional social network usable by our working builds of the app.

### What we learned
We learned a lot about the very basics of SwiftUI and Firestore, as well as how they communicate with each other. We also spent time studying how the Firestore APIs work in-depth through our struggles with asynchronous calls and live snapshot-based updating.

### What's next for Beacon
There are many features that could be modularly added to Beacon in the future given more time to work on the project, such as working push notifications, better UI, messages and voice notes in alerts, and others. We could also expand the social network feature to accommodate different levels of friendships and more basic functionality.
