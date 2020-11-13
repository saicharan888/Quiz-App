import * as React from 'react';
import { NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';

import HomeScreen from './HomeScreen';
import QuizScreen from './QuizScreen';

const Stack=createStackNavigator();


//Handles the navigation of screens 
const Navigation = props => {
    return (
        <NavigationContainer>
            <Stack.Navigator initialRouteName="HomeScreen">
                <Stack.Screen name="HomeScreen" component={HomeScreen} title={"hi"} options={{headerShown:false}}/>
                <Stack.Screen name="QuizScreen" component={QuizScreen} options={{headerShown:false}}/>
            </Stack.Navigator>
        </NavigationContainer>

    );
};

export default Navigation;