// this file is util function list.

// create a function that can be used repeatedly in many places.
// Naming rules consist of "purpose-functions".

// for example.
// if you want create `location to string` function.
// the function name will be `location_toString()`

// and dont forget comment on your function.
// it saves a lot of energy when it comes to how to use this function

// ----------------------------------------------------------------------

import java.util.Map

// put the map in the global variable
//
// params -
// rootPath : The path that starts the global variable.
// map : Map to enter the global variable.
// isTemp : If it is true, save it to the Temporary Global-Variable.
//
// return -
// void
globalVar_putMap = LAMBDA rootPath, map, isTemp =>
    SYNC

        FOR entry = map.entrySet()
            currentPath = rootPath + "." + entry.getKey()
            
            IF entry.getValue() IS Map
                globalVar_putMap(currentPath, entry.getValue(), isTemp)
            ELSE
                IF isTemp
                    {?currentPath} = entry.getValue()
                ELSE
                    {currentPath} = entry.getValue()
                ENDIF
            ENDIF
        ENDFOR
        
    ENDSYNC
ENDLAMBDA