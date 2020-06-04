import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as algolia from 'algoliasearch';


admin.initializeApp();
const client = algolia.default('QBA7WQDNJ8', '70600e8d07bfd646b9694c59d8bc39dd');
const index = client.initIndex('users')

// noinspection JSUnusedGlobalSymbols
export const onCreatePost = functions
    .firestore
    .document('likes/{likeId}')
    .onCreate(async (snapshot) => {
        let parent: string;

        if (snapshot.data()!.type === 'post') {
            parent = 'posts';
        } else if (snapshot.data()!.type === 'comment') {
            parent = 'comments';
        } else {
            throw new Error('this parent does not exists $type')
        }

        const parentRef = admin.firestore().doc(`${parent}/${snapshot.data()!.parentId}`);

        await parentRef.update({'likes': admin.firestore.FieldValue.increment(1)});

    });

// Update like count on like parent
// noinspection JSUnusedGlobalSymbols
export const onDeleteLike = functions
    .firestore
    .document('likes/{likeId}')
    .onDelete(async (snapshot) => {
        const type = snapshot.data()!.type;
        const parentId = snapshot.data()!.parentId;

        let parent: string;
        if (type === 'post') {
            parent = 'posts';
        } else if (type === 'comment') {
            parent = 'comments';
        } else {
            throw new Error(`This parent does not exists ${type}`);
        }

        const parentRef = admin.firestore().doc(`${parent}/${parentId}`);
        await parentRef.update({'likes': admin.firestore.FieldValue.increment(-1)});
    });

// noinspection JSUnusedGlobalSymbols
export const onCreateUser = functions
    .firestore
    .document(`users/{uid}`)
    .onWrite(async (change, context) => {
        const uid: string = context.params.uid;

        if (!change.after.exists) {
            await index.deleteObject(uid);
        } else {
            const data = change.after.data()!;
            await index.saveObject({'objectID': uid, ...data});
        }
    });

// noinspection JSUnusedGlobalSymbols
export const checkUsername = functions
    .https
    .onCall(async (data: any, context) => {
        if (!data.username) {
            throw new functions.https.HttpsError("invalid-argument", "You need to provide a username");
        }

        const username: string = data.username;
        const snapshot = await admin.firestore()
            .collection('users')
            .where('username', '==', username)
            .get();

        return snapshot.docs.length === 0 ? username : null;
    });

// noinspection JSUnusedGlobalSymbols
export const setLastMessage = functions
    .firestore
    .document('messages/{message_id}')
    .onCreate(async (snapshot) => {
        const chatId: string = snapshot.data()!.chatId;

        await admin.firestore()
            .doc(`chats/${chatId}`)
            .update({ 'lastMessage': snapshot.data() });
    });