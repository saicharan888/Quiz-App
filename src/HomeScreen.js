import React, { Component } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  TextInput,
  TouchableOpacity
} from 'react-native';

import {
  Colors,
} from 'react-native/Libraries/NewAppScreen';

import AsyncStorage from '@react-native-async-storage/async-storage';
import  RNFS from 'react-native-fs';



var path = RNFS.DocumentDirectoryPath + '/test2.txt';

class HomeScreen extends Component {

  state = {
    firstName:'',
    lastName:'',
    nickName:'',
    age:'',
    score:'',
    firstNameError:false,
    lastNameError:false,
    nickNameError:false,
    ageError:false,
    scoreExists:false
  }

  constructor(props){
    super(props);
    this.getData();
    this.checkFile().then((value) => {
      if (value === true){
        this.readFile();
      }
    });
    }

  
  // to check if file is present that stores score
  checkFile = async () =>{
    try{
      var fileCheck = await RNFS.exists(path, 'utf8');
      return Boolean(fileCheck);
    }
    catch(error){
      return false;
    }
  }

  //read the scores from file 
  readFile = async () =>{
    try{
      var fileData = await RNFS.readFile(path, 'utf8');
      this.setState({
        scoreExists:true,
        score:fileData
      })
    }
    catch(error){
      Alert.alert('Failed to read the score from File');
    }
  }

  // stores data in async storage
  setData = async () => {
    try {
      await AsyncStorage.setItem('firstName', this.state.firstName)
      await AsyncStorage.setItem('lastName', this.state.lastName)
      await AsyncStorage.setItem('nickName', this.state.nickName)
      await AsyncStorage.setItem('age', this.state.age)
    } 
    catch (e) {
      Alert.alert('Failed to store data in Async Storage');
    }
  }

  // gets data from async storage
  getData = async () => {
    try {
      const firstNameValue = await AsyncStorage.getItem('firstName');
      const lastNameValue = await AsyncStorage.getItem('lastName');
      const nickNameValue = await AsyncStorage.getItem('nickName');
      const ageValue = await AsyncStorage.getItem('age');
      if (firstNameValue !== null || lastNameValue !== null || nickNameValue !== null || ageValue !== null) {
        this.setState({
          firstName:firstNameValue,
          lastName:lastNameValue,
          nickName:nickNameValue,
          age:ageValue
        })
      }
    } 
    catch (error) {
      Alert.alert('Failed to fetch data from Async Storage');
    }
  };


  // validates the form 
  validate = () => {
    var firstNameValidator=false;
    var lastNameValidator=false;
    var nickNameValidator=false;
    var ageValidator=false;
    if(!this.state.firstName.trim()){
      firstNameValidator=true;
    }
    if(!this.state.lastName.trim()){
      lastNameValidator=true;
    }
    if(!this.state.nickName.trim()){
      nickNameValidator=true;
    }
    if(this.state.age.length === 0 || isNaN(this.state.age)){
      ageValidator=true;
    }
    if(firstNameValidator || lastNameValidator || nickNameValidator || ageValidator){
      this.setState({
        firstNameError:firstNameValidator,
        lastNameError:lastNameValidator,
        nickNameError:nickNameValidator,
        ageError:ageValidator
      })
      return false;
    }
    return true;

  }

  openQuizScreen = () => {
    if(this.validate()){
      this.setData();
      this.props.navigation.replace('QuizScreen');
    }
    
  };

  firstNameInput = (val) =>{
    if(val!==null){
      this.setState(
        {
          firstName:val,
          firstNameError:false
        }
      );
    }
  }

  lastNameInput = (val) =>{
    if(val!==null){
      this.setState(
        {
          lastName:val,
          lastNameError:false
        }
      );
    }
  }

  nickNameInput = (val) =>{
    if(val!==null){
      this.setState(
        {
          nickName:val,
          nickNameError:false
        }
      );
    }
  }

  ageInput = (val) =>{
    if(val!==null){
      this.setState(
        {
          age:val,
          ageError:false
        }
      );
    }
  }
  
  render(){
     //displaying error texts 
    let firstNameErrorText=null;
    if (this.state.firstNameError) { 
      firstNameErrorText = <View><Text style={styles.errorText}> field cannot be empty </Text></View>;    
    }

    let lastNameErrorText=null;
    if (this.state.lastNameError) { 
      lastNameErrorText = <View><Text style={styles.errorText}> field cannot be empty </Text></View>;    
    }

    let nickNameErrorText=null;
    if (this.state.nickNameError) { 
      nickNameErrorText = <View><Text style={styles.errorText}> field cannot be empty </Text></View>;    
    }

    let ageErrorText=null;
    if (this.state.ageError) { 
      ageErrorText = <View><Text style={styles.errorText}> enter valid age </Text></View>;    
    }

    // display the scores if quiz taken
    let scoreDisplay=null;
    if(this.state.scoreExists){
      scoreDisplay = <View><Text style={styles.scoreText}> Current Score : {this.state.score} </Text></View>;  
    }

    return (
        <SafeAreaView style={styles.backGround}>
        <ScrollView
          contentInsetAdjustmentBehavior="automatic"
          style={styles.scrollView}>
          <View style={styles.body}>
            <Text style={styles.header}> Quiz App </Text>
            <Text style={styles.formHeading}> First Name </Text>
            <TextInput style={styles.inputBox} 
              placeholder = "Enter first name"
              keyboardType ="default"
              defaultValue= {this.state.firstName}
              onChangeText ={(val)=>this.firstNameInput(val)}
            />
            {firstNameErrorText}
            <Text style={styles.formHeading}> Last Name </Text>
            <TextInput style={styles.inputBox}
              placeholder = "enter last name"
              keyboardType ="default"
              defaultValue={this.state.lastName}
              onChangeText ={(val)=>this.lastNameInput(val)}
            />
            {lastNameErrorText}
            <Text style={styles.formHeading}> Nick Name </Text>
            <TextInput style={styles.inputBox}
              placeholder = "enter nick name"
              defaultValue={this.state.nickName}
              keyboardType ="default"
              onChangeText ={(val)=>this.nickNameInput(val)}
            />
            {nickNameErrorText}
            <Text style={styles.formHeading}> Age </Text>
            <TextInput style={styles.inputBox}
              placeholder = "enter age"
              defaultValue={this.state.age}
              keyboardType ="numeric"
              onChangeText ={(val)=>this.ageInput(val)}
            />
            {ageErrorText}
            {scoreDisplay}
            <TouchableOpacity 
              style={styles.button}
              onPress={this.openQuizScreen}>
              <Text style={styles.buttonText}>Login</Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </SafeAreaView>
    )
  };
};


// styling for the form 
const styles = StyleSheet.create({
    backGround:{
      backgroundColor:"#1c313a",
      flex:7
    },
    inputBox:{
      color:'#ffffff',
      width:300,
      paddingHorizontal:16,
      borderRadius:25,
      fontSize:20,
      height:50,
      backgroundColor:'rgba(255,255,255,0.3)',
      marginTop:2
    },
    header:{
      color:'#ffffff',
      textAlign:"center",
      textAlignVertical:"center",
      borderRadius:25,
      fontSize: 40,
      fontWeight: "bold",
      marginVertical:50
    },
    formHeading:{
      color:'#ffffff',
      width:300,
      fontSize:16,
      fontWeight: 'bold',
      marginTop:14
    },
    errorText : {
      color:'#cd5c5c',
      width:300,
      fontSize:16,
      fontWeight: 'bold',
      textAlign:'center'
    },
    body: {
      alignItems:'center',
      textAlignVertical:'center',
      flexGrow:2
    },
    buttonText:{
      fontSize:20,
      fontWeight:'500',
      color:'#ffffff',
      textAlign:'center',
      fontWeight:'bold',
      paddingVertical:9
    },
    button:{
      backgroundColor:Colors.black,
      borderRadius:500,
      width:130,
      height:50,
      marginVertical:10,
      marginTop:20
    },
    scoreText:{
      color:'#ffffff',
      textAlign:"center",
      textAlignVertical:"center",
      borderRadius:25,
      fontSize: 25,
      fontWeight: "bold",
      marginTop:20
    }
  });



  export default HomeScreen