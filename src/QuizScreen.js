import React from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  TouchableOpacity,
  BackHandler,
  Alert
} from 'react-native';

import {
  Colors
} from 'react-native/Libraries/NewAppScreen';

import './assests/data.json';
import  RNFS from 'react-native-fs';



var path = RNFS.DocumentDirectoryPath + '/test2.txt';

const customData = require('./assests/data.json');
const totalQuestions=Object.keys(customData[0]).length;
class QuizScreen extends React.Component{
  state={
    currentQuestion:1,
    selectedOption:-1,
    answered:false,
    correctCount:0,
    questionCount:totalQuestions,
    lastQuestion:false
  }

  constructor(props){
    super(props);
  }

  // handles the completion of quiz (disables back button )
  componentDidMount() {
    BackHandler.addEventListener('hardwareBackPress', this.handleBackButton);
  }
  
  componentWillUnmount() {
    BackHandler.removeEventListener('hardwareBackPress', this.handleBackButton);
  }
  
  handleBackButton() {
    Alert.alert('Please Complete Quiz');
    return true;
  }

  // stores score in a file 
  writeFile = async () =>{
    try{
      await RNFS.writeFile(path, this.state.correctCount.toString(), 'utf8');
    }
    catch(error){
      Alert.alert('Failed to store the score');
    }
  }

  // redenring the different question or if quiz complete navigates to homescree
  nextQuestion=() => {
    if(customData[2][this.state.currentQuestion]===customData[1][this.state.currentQuestion][this.state.selectedOption]){
      this.state.correctCount=this.state.correctCount+1;
    }
    if(this.state.currentQuestion === this.state.questionCount){
      this.writeFile().then(() => {
        this.props.navigation.replace('HomeScreen');
      });
    }else{
      this.setState(
      {
        currentQuestion: this.state.currentQuestion + 1,
        answered:false,
        selectedOption:-1
      }
    );
    }
  }

  // used to color the button that is selected
  Click(key){
    this.setState(
      {
        selectedOption:key,
        answered:true
      }
    );
  }


  
  render(){
    var questionOptions = [];

    // creating the options display 
    for (let i = 1; i < 5; i++) {
      questionOptions.push(
          <TouchableOpacity
            style={{
              color:'#ffffff',
              width:300,
              paddingHorizontal:16,
              borderRadius:45,
              fontSize:20,
              height:50,
              alignSelf:"center",
              backgroundColor:this.state.selectedOption===i ? '#006400' : Colors.black,
              marginVertical:15
            }} 
            key={i}
            onPress = {() => (this.Click.bind(this))(i)}>
            <Text style={styles.buttonText}>{customData[1][this.state.currentQuestion][i]}</Text>
          </TouchableOpacity>
      );
    };

    let buttonTextCheck;
    
    if(this.state.currentQuestion===this.state.questionCount){
      this.state.lastQuestion=true;
      buttonTextCheck=<Text style={styles.buttonText}>submit</Text>;
    }else{
      buttonTextCheck=<Text style={styles.buttonText}>next</Text>;
    }

    // handles the display of next button 
    let nextButton;
    if(this.state.answered===true){
      nextButton=<View>
      <TouchableOpacity 
        style={styles.submitButton}
        onPress={this.nextQuestion}
        >
        {buttonTextCheck}
      </TouchableOpacity>
    </View>
    }
    
    return (
        <SafeAreaView style={styles.backGround}>
        <ScrollView
          contentInsetAdjustmentBehavior="automatic"
          style={styles.scrollView}>
          <View style={styles.body}>
            <Text style={styles.question}>{this.state.currentQuestion}). {customData[0][this.state.currentQuestion]} </Text>
          </View>
          <View style={styles.optionPart}>
            <Text style={styles.emptyTerm} />
            {questionOptions}
            {nextButton}
          </View>
        </ScrollView>
      </SafeAreaView>
    )
  }
};

// styling for the questions 
const styles = StyleSheet.create({
  question:{
    color:'#ffffff',
    textAlign:"center",
    paddingVertical:16,
    paddingHorizontal:16,
    textAlignVertical:"center",
    borderRadius:25,
    fontSize: 20,
    fontWeight: "bold",
    marginVertical:50,
    height:130,
  },
  body: {
    paddingHorizontal:20,
    alignItems:'center',
    textAlignVertical:'center',
    backgroundColor:"#1c313a",
    flex:3
  },
  buttonText:{
    fontSize:20,
    fontWeight:'500',
    color:'#ffffff',
    textAlign:'center',
    paddingVertical:9
  },
  emptyTerm: {
    marginLeft: 5,
    marginRight: 5,
    minWidth: "25%"
  },
  submitButton :{
    color:'#ffffff',
    width:200,
    paddingHorizontal:16,
    borderRadius:45,
    fontSize:20,
    height:50,
    alignSelf:"center",
    backgroundColor:'#00008b',
    marginVertical:15       
  },
  optionPart:{
    flex:5
  }
});

export default QuizScreen