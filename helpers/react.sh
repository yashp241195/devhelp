declare -A helper
declare -A hint


hint["react-basic"]="Setup the basic project in react.js"
helper["react-basic"]="
hint : ${hint["react-basic"]}

# Install basic react project
$ npm i create-react-app

# Create the react app 'myapp'
$ create-react-app myapp

"

hint["react-redux"]="Setup the redux in react.js"
helper["react-redux"]="
hint : ${hint["react-redux"]}

// Create the react app 'myapp'
$ create-react-app myapp

// install the redux
$ npm i redux react-redux

// create project structure
$ mkdir components containers services 

$ touch components/Home.js containers/HomeContainer.js 
$ cd services
$ mkdir actions reducers 
$ touch actions/actions.js reducers/rootReducers.js reducers/reducers.js constants.js

// inside index.js 

import {createStore} from 'redux'
import {Provider} from 'react-redux'
import rootReducer from './services/reducers/rootReducer'

const store = createStore(rootReducer);

ReactDOM.render(
    <Provider store={store}>
      <App />
    </Provider>,
  document.getElementById('root')
);

// inside App.js

import HomeContainer from './containers/HomeContainer'

function App() {
  return (
    <div>
      <HomeContainer />
    </div>
  );
}

export default App;


// Inside './containers/HomeContainer'

import {connect} from 'react-redux'
import Home from '../components/Home'
import {addToCart} from '../services/actions/actions'


const mapStateToProps = state => ({
    cartData:state
})

const mapDispatchToProps = dispatch => ({
    addToCartHandler:data=>dispatch(addToCart(data))
})

export default connect(mapStateToProps,mapDispatchToProps)(Home);

// Inside '../components/Home'

import React from 'react'

const Home = (props) => {

    return (
        <div>
            Home Component
            <div>
                <div> Name : I Phone </div> 
                <div> Price : 1000 USD  </div> 
                <div> 
                    <button onClick={()=>props.addToCartHandler({price:1000, name:' I Phone X'})} > Add To Cart </button> 
                </div> 
            </div>
        </div>
    )
}

export default Home

// Inside 'services/constants.js'

export const ADD_TO_CART = 'ADD_TO_CART'

// Inside 'services/actions/actions.js'

import {ADD_TO_CART} from '../constants';

export const addToCart = (data) => {
    return {
        type : ADD_TO_CART,
        data : data
    }
}

// Inside 'services/reducers/rootReducer.js'

import {combineReducers} from 'redux'
import cartItems from './reducers'

export default combineReducers({
    cartItems,
})

// Inside 'services/reducers/reducers.js'

import {ADD_TO_CART} from '../constants'

const initialState = {
    cartData:[]
}

export default function cartItems(state=initialState, action){
    switch(action.type){
        case ADD_TO_CART:
            return {
                ...state,
                cartData : action.data
            }
        default: return state
    }

}

"

hint["react-graphql"]="Setup the basic graphql in react.js"
helper["react-graphql"]="
hint : ${hint["react-graphql"]}

# Install basic react project
$ npm i create-react-app

# Create the react app 'myapp'
$ create-react-app myapp

// install the graphql
$ npm i graphql react-apollo apollo-boost lodash


$ mkdir components queries
$ touch queries/queries.js

$ cd components
$ touch AddBook.js BookDetails.js BookList.js

// Inside App.js

import AddBook from './components/AddBook';
import BookList from './components/BookList';

import ApolloClient from 'apollo-boost';
import { ApolloProvider } from 'react-apollo';

const client = new ApolloClient({
  uri: 'http://localhost:3005/graphql',
});


function App() {
  return (
    <div>
      <ApolloProvider client={client}>
      <div> 
        <div style={{ paddingTop:50, paddingLeft:50, }}>
          <AddBook />
        </div>
        <br />
        <div style={{ paddingTop:50, paddingLeft:50,}}>
          <BookList />
        </div>
      </div>
      </ApolloProvider>
    </div>
  );
}

export default App;

// Inside 'queries/queries.js'

import { gql } from 'apollo-boost';

const getAuthorsQuery = gql\`
    {
        authors {
            name
            id
        }
    }
\`;

const getBooksQuery = gql\`
    {
        books {
            name
            id
        }
    }
\`;

const addBookMutation = gql\`
    mutation AddBook($name: String!, $authorid: Int!){
        addBook(name: $name, authorid: $authorid){
            name
            id
        }
    }
\`;

const getBookQuery = gql\`
    query GetBook($id: ID){
        book(id: $id) {
            id
            name
            author{
                name
                books{
                    id
                    name
                }
            }
        }
    }
\`;

export { getAuthorsQuery, getBooksQuery, addBookMutation, getBookQuery };

// inside 'components/AddBook.js'

import React, {useState} from 'react'
import { graphql } from 'react-apollo';
import {flowRight as compose} from 'lodash';
import { getAuthorsQuery,getBookQuery, addBookMutation, getBooksQuery } from '../queries/queries';

const AddBook = (props) => {

    const [name, setName] = useState('')
    const [authorId, setAuthorId] = useState(1)

    const author_option = [
        { id: 1, name: 'J. K. Rowling' },
	    { id: 2, name: 'J. R. R. Tolkien' },
	    { id: 3, name: 'Brent Weeks' }
    ]

    const onSubmit = () => {
        
        props.addBookMutation({
            variables: {
                name: name,
                authorid: authorId
            },
            refetchQueries: [
                { query: getBooksQuery },
                { query: getBookQuery}
            ]
        });
    }

    return (
        <div>
            Add Book
            <br />
            <br />
            Book Name : <input type=\"text\" onChange={ (e) => setName(e.target.value) } />
            <br />
            {/* {name} */}
            <br />
            <label htmlFor=\"author\">Author : </label>
            <select id=\"author\" value={authorId} onChange={(e) => setAuthorId(e.target.value)}>
                {author_option.map((item)=>{
                    const {id, name} = item 
                    return <option key={id} value={id} >{name}</option>
                })}
            </select>
            <br />
            {/* {authorId} */}
            <br />
            <input type=\"submit\" onClick={()=>onSubmit()} />
            <br />
        </div>
    )
}

export default compose(
    graphql(getAuthorsQuery, { name: \"getAuthorsQuery\" }),
    graphql(addBookMutation, { name: \"addBookMutation\" })
)(AddBook); 

// Inside 'components/BookDetails.js'

import React from 'react'
import { graphql } from 'react-apollo';
import { getBookQuery } from '../queries/queries';

const BookDetails = (props) => {

    
    const displayBookDetails = () => {
        const { book } = props.data;
        
        console.log('book : ',JSON.stringify(book,null,2))

        if(book){
            return (<div>
                <br />
                id : {book.id}
                <br />
                name : {book.name}
                <br />
                author : {book.author.name}
                <br />
                All books by Author
                <br />
                {
                    book.author.books.map((item, i)=>{
                        return <li key={i} > id: {item.id} name : {item.name}</li>
                    })
                }
            </div>)  
        }else{
            return (<div> No books found .. </div>)
        }

    }
    
    return (
        <div>
            BookDetails
            <br />
            <div>
            {displayBookDetails()}
            </div>
            <br />
        </div>
    )
}

export default graphql(getBookQuery, {
    options: (props) => {
        return {
            variables: {
                id: props.bookId
            },
        }
    }
})(BookDetails);


// Inside 'components/BookList.js'

import React, { useState } from 'react'
import { graphql } from 'react-apollo';
import { getBooksQuery } from '../queries/queries';
import BookDetails from './BookDetails';

const BookList = (props) => {

    const [selected, setSelected] = useState(1)

    const onSelected = (id) =>{ 
        setSelected(() => id)
    }

    const displayBooks = () => {

        let data = props.data;
        
        if(data.loading){
            return( <div> Loading books .. </div> );
        } else {
            return data.books.map(book => {
                const {id, name} = book
                return(
                    <li key={ id } onClick={ (e) => {onSelected(id)} } >  { name }  </li> 
                );
            })
        }
    }

    return (
        <div>
            <br />
            <div style={{display:'flex'}}>
                <div style ={{width:400}}>
                    BookList
                    <br />
                    <ul id=\"book-list\">
                        {displayBooks()}
                    </ul>
                </div>
                <div style ={{width:600}}>
                    <BookDetails bookId={selected}/>
                </div>
            </div>
            <br />
        </div>
    )
}

export default graphql(getBooksQuery)(BookList)


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
