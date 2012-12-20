db = db.getSiblingDB("OBP006");
db.temp.insert({"blub":"blubblub"});
db.dropDatabase();

////////
//Creating data
////////
var anon=0
var balance_start = Math.floor(1000000*(Math.random()-Math.random()))/100;
var balance = balance_start;
var date=new Date();
bankID = ObjectId();
var this_bank={"_id": bankID, "SWIFT_BIC" : "" , "website" : "" , "name" : "POSTBANK" , "permalink" : "postbank" , "national_identifier" : "" , "email" : "" , "alias" : "" , "logo" : ""};
var this_acc=newAcc();
this_acc={ "number" : "0580591101", "kind" : "current", "holder" : "Music Pictures Limited", "bank" : { "name" : "POSTBANK", "IBAN" : "", "national_identifier" : "" } }

////////
//Inserting data
////////
db.accounts.insert({"currency":"EUR", "number" : "0580591101", "holder" : "Music Pictures Limited", "label" : "tesobe", "bank" : { "name" : "POSTBANK", "IBAN" : "", "national_identifier" : "" }, "kind" : "current", "anonAccess" : true, "permalink" : "tesobe", "bankID" : bankID, "otherAccounts": []});
db.obpenvelopes.insert(newEnv());
db.obpenvelopes.insert(newEnv());
db.obpenvelopes.insert(newEnv());
db.obpenvelopes.insert(newEnv());
db.obpenvelopes.insert(newEnv());
db.hostedbanks.insert(this_bank);

////////
//Data-creation helpers
////////
function ISODateString(d){
 function pad(n){return n<10 ? '0'+n : n}
 return d.getUTCFullYear()+'-'
     + pad(d.getUTCMonth()+1)+'-'
     + pad(d.getUTCDate())+'T'
     + pad(d.getUTCHours())+':'
     + pad(d.getUTCMinutes())+':'
     + pad(d.getUTCSeconds())+'.001Z'
}


function newAlias() {
 holder = "holder"+Math.round(100*Math.random());
 if(Math.random()>.4){
 if(anon==0)
 db.accounts.update({},{$push: {"otherAccounts": 
{"privateAlias" : "Google ", "url" : "http://google.com/", "holder" : holder, "moreInfo" : "Google inc", "publicAlias" : "publicAlias1", "imageUrl" : "http://www.google.de/images/srpr/logo3w.png"}}})
 if(anon==1)
 db.accounts.update({},{$push: {"otherAccounts": 
{"privateAlias" : "Google ", "url" : "http://google.com/", "holder" : holder, "moreInfo" : "Google inc", "publicAlias" : "publicAlias2", "imageUrl" : "http://www.google.de/images/srpr/logo3w.png"}}})
 if(anon==2)
 db.accounts.update({},{$push: {"otherAccounts": 
{"privateAlias" : "Google ", "url" : "http://google.com/", "holder" : holder, "moreInfo" : "Google inc", "publicAlias" : "publicAlias5", "imageUrl" : "http://www.google.de/images/srpr/logo3w.png"}}})}
 anon++
 return holder
}

function newBank() {
 return {
  "name" : "bank"+Math.round(100*Math.random()),
  "IBAN" : "DE"+Math.round(10000000000*Math.random()),
  "national_identifier" : ""
 }
}
function newAcc() {
 return {
    "number" : Math.round(100000000*Math.random()),
    "kind" : "kind"+Math.round(100*Math.random()),
    "holder" :  newAlias(),
    "bank" : newBank()
   }
}
function newValue() {
 return {
    "amount" : Math.floor(10000*(Math.random()-Math.random()))/100,
    "currency" : "EUR"
 }
}

function newComment() {
 commentID = ObjectId();
 db.obpcomments.insert({"_id": commentID, "textField": "comment"+Math.round(8*Math.random()), "viewID" : 1+Math.round(8*Math.random()),"date" : ISODateString((date.getTime() + Math.round(2000000*Math.random()))) , "userId" : 1 });
 return commentID
}
function newCommentAnon() {
 commentID = ObjectId();
 db.obpcomments.insert({"_id": commentID, "textField": "comment"+Math.round(8*Math.random()), "viewID" : 6,"date" : ISODateString((date.getTime() + Math.round(2000000*Math.random()))) , "userId" : 1 });
 return commentID
}
function newEnv() {
 date = new Date(date.getTime() - Math.round(100000000*Math.random()));
 var value = newValue();
 balance += value.amount;
 balance = Math.round(balance*100)/100
 var comments=[newComment(), newCommentAnon()];
 return {
  "obp_comments" : comments,
  "obp_transaction" : {
   "details" : {
    "new_balance" : {
     "amount" : balance,
     "currency" : "EUR"
    },
    "other_data" : "customer"+Math.round(100*Math.random()),
    "completed" : ISODateString(date),
    "type_en" : "",
    "value" : value,
    "posted" : ISODateString(date),
    "type_de" : "Type"+Math.round(100*Math.random())
   },
   "this_account" : this_acc,
   "other_account" : newAcc()
  },
  "narrative" : ""
 }
}
