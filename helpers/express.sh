declare -A helper
declare -A hint

hint["node-install"]="Check if node and npm installed or not"
helper["node-install"]="
hint : ${hint["node-install"]}

Check it with the help of versions of node and npm

$ node --version
$ npm --version
"

hint["express-rest-api"]="Setting up express js rest api server"
helper["express-rest-api"]="
hint : ${hint["express-rest-api"]}

initalise the node project package.json
$ npm init -y

install following packages 
(i) nodemon for monitoring the server, 
(ii) express for setting up express server
(iii) morgan for debugging the requests
(iv) body-parser for parsing the json data in post request
(v) cors for cross origin requests

$ npm i nodemon express morgan body-parser cors 

create index.js file to entry point to the server 
$ touch index.js 

// inside index.js file

const express = require('express')
const morgan = require('morgan')
const bodyParser = require('body-parser')
const cors = require('cors') 

const app = express()
app.use(cors())
app.use(morgan('dev'));
app.use(bodyParser.json()); // for json data
// app.use(bodyParser.urlencoded({ extended: true })) // for form data

app.get('/test',()=>{
  res.json({
    message:'testing'
  })
})

const PORT = process.env.PORT || 3005 

app.listen(PORT,()=>{
  console.log('Welcome to express rest api app')
})

// add dev script in package.json 

'scripts': {
    'dev': 'nodemon index.js',
},


done !!
"

hint["express-rest-api-arch"]="Splitting the code into models routes controllers architecture"

helper["express-rest-api-arch"]="
hint : ${hint["express-rest-api-arch"]}

Create the folder structure as

(i) models : to map javascipt object with database so that we can perform database operations
(ii) controllers : to define the functionalities 
(iii) routes : to define the routings

$ mkdir api
$ cd api

$ mkdir models controllers routes
$ touch models/user.js controllers/user.js routes/user.js

// modify index.js add the 'user' middleware

app.use('/user',require('./api/routes/user'))  

// modify 'routes/user.js' and add express router

var express = require('express');
var router = express.Router();

const UserController = require('../controller/user')

router.get('/info',UserController.info);

module.exports = router;

// modify 'controllers/user.js' controller file

module.exports = {
    info: (req,res)=>{
    res.json({
       message:'Getting the user info'	
    })
},

// Save and test whether server is working or not with modified architecture

Go to 'express-rest-api-mongo' to understand how to setup models with mongodb

done !!
"

hint["express-rest-api-mongo"]="Basic Create Read Update Delete operations with mongodb"

helper["express-rest-api-mongo"]="
hint : ${hint["express-rest-api-mongo"]}

// modify index.js setup the mongodb connection

const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoose.set('useCreateIndex', true);

const mongo_url = process.env.MONGODB_URI || 'mongodb://localhost/userdb'

mongoose.connect(
    mongo_url, { useNewUrlParser: true,  useUnifiedTopology: true }
).then(connect => console.log('connected to mongodb..'))
.catch(e => console.log('could not connect to mongodb', e))


// create the model User 'models/user.js'

const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    name: String,
    email: String
})

const User = mongoose.model('user',UserSchema)

module.exports = User;

// modify the router 'routes/user'

router.get('/info/:name',UserController.info);

// modify the controller 'controllers/user'

module.exports = {

    info: async (req,res)=>{

    // async await will be used because mongodb will take time to response
    const user = await User.find({name:req.query.name})

    res.json({
       user: user,
       message:'Getting the user info'	
    })

},

Processing Inputs : 

GET Request inputs 
router.get('/info/:name',UserController.info);

const name = req.query.name

POST Request inputs 
router.post('/info',UserController.info);

const name = req.body.name

// Mongo Schemas data types : 

name: {
 type: String,
 index: true,
 unique:true, 
 dropDups: true
},

type: string data type
index : indexing will be done on the basis of 'name'by storing into b/b+ tree for faster access.
unique : ensure only unique values are allowed
dropDups : drop the duplicates

userCreatedAt:{
 type: Date,
 default: Date.now()
}

default is for setting up the default value for this


// Processing post request inputs and inserting into mongodb 

const {name, email} = req.body;
const newUser = new User({ 'name':name, 'email': email, })
        
try {
    const response = await newUser.save()
    res.json({
        response: response ,
        message:'user successfully inserted'
    })
}catch(e){
    res.json({
        response: e ,
        message:'user insertion failed'
    })
}

// Processing post request inputs and updating into mongodb
 
const {name, email} = req.body;
let updatedPlaceDetails = {}

Boolean(name) && (updatedPlaceDetails['name'] = name)
Boolean(email) && (updatedPlaceDetails['email'] =  email)

try {
const response = await Place.updateOne({ 'name': name }, { $set: updatedPlaceDetails })
res.json({
  response: response ,
  message:'user successfully updated'
})
}catch(e){
  res.json({
     response: e ,
     message:'user update failed'
  })
}

done !!
"

hint["express-graphql"]="Setting up the graphql server"
helper["express-graphql"]="
hint : ${hint["express-graphql"]}

install packages to setup graphql

$ npm i nodemon express express-graphql @graphql-tools 

Create the folder structure as
(i) models : to map javascipt object with database so that we can perform database operations
(ii) schemas : to setup schema for the particular data type
   a) schema : to define the kinds of inputs a server is interested to recieve. 
   b) resolvers : object which resolves or instruct what to do with the incoming requests.

$ mkdir graphql
$ cd graphql
$ mkdir schema 
$ cd schema
$ touch main-resolver.js main-type.js

// inside index.js

const express = require('express')
const morgan  = require('morgan')
const cors = require('cors')

app.use(cors())
app.use(morgan('dev'))

const { graphqlHTTP } = require('express-graphql');

const {makeExecutableSchema,} = require('@graphql-tools/schema');
const {mergeResolvers, mergeTypeDefs} = require('@graphql-tools/merge')

const mainRes = require('./graphql/schemas/main-resolver')
const mainTypes = require('./graphql/schemas/main-type')

registerTypes = mergeTypeDefs([mainTypes])
registerResolvers = mergeResolvers([mainRes])

app.use('/graphql', graphqlHTTP({
  schema: makeExecutableSchema({
    typeDefs: registerTypes,
    resolvers: registerResolvers,
  }),
  graphiql: true
}))

const PORT = process.env.PORT || 3005

app.listen(PORT, ()=>{
    console.log('Welcome to GraphQL tutorial ');
})

// inside the main-type.js

// UserType is to define the datatype
// Query is to define the kind of possible queries
// Mutation is to define the way in which we can insert/update the data

const schema = \`
    type UserType {
        id: ID!
        name: String!
        email: String
    }
    type Query {
        user(id:ID):UserType
        users:[UserType]
    }
    type Mutation{
        addUser(name:String!,email:String!):UserType
    }
\`

module.exports = schema

// Inside main-resolver.js

// allusers could be exported from the models as well

const allusers = [
 {id:0, name:'Yash',email:'yash@mail.com'},
]

const userResolver = {
    Query: {
        user: (parent, args) => allusers.find(user => user.id === parseInt(args.id)),
        users: () => allusers,
    },
    Mutation:{
        addUser:(parent, args) => {
            const user = { id: allusers.length + 1, name: args.name, email: args.email }
            allusers.push(user)
            return user
        }
    }
};

module.exports = userResolver
"

echo "${helper[$1]}"

if [[ $1 == "--list" ]];
then 
for i in "${!hint[@]}"; do echo "$i - ${hint[$i]}"; done
elif [[ $1 == "--all" ]];
then
echo ""
fi
echo " "

