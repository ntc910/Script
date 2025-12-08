cpp_ver="-std=c++14"

Color_Off='\033[0m'       # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

###########################################

# Check number of parameters to determine execution mode
if [ $# -eq 2 ]; then
    # Case 1: 1 .cpp file + 1 .txt file
    file_main=$1
    file_inpt=$2
    
    # Check if first parameter is .cpp and second is .txt
    if [[ $file_main == *.cpp ]] && [[ $file_inpt == *.txt ]]; then
        echo "${Green}Running single C++ file with input: ${file_main} < ${file_inpt}${Color_Off}"
        
        # Copy input file to temp directory
        if [ -f "$file_inpt" ]; then
            cp $file_inpt ~/.tmp/$file_inpt
        fi
        
        # Compile the C++ file
        if [ -f "$file_main" ]; then
            g++ $cpp_ver $file_main -o ~/.tmp/run
        else
            echo "No file ?"
            exit 1
        fi
        
    else
        echo "${Red}Error: For 2 parameters, first must be .cpp file and second must be .txt file${Color_Off}"
        exit 1
    fi
    
elif [ $# -eq 3 ]; then
    # Case 2: Original functionality - main file, user file, input file
    file_main=$1
    file_user=$2
    file_inpt=$3
    
    if [ -f "$file_inpt" ]; then
        cp $file_inpt ~/.tmp/$file_inpt
    fi

    if [ -f "$file_main"  ]; then
        if [ -f "$file_user" ]; then
            g++ $cpp_ver $file_main $file_user -o ~/.tmp/run
        else
            g++ $cpp_ver  $file_main -o ~/.tmp/run
        fi
    else
        echo "No file ?"
        exit 1
    fi
    
else
    echo "${Red}Usage:${Color_Off}"
    echo "  ${Yellow}Single file mode:${Color_Off} $0 <cpp_file> <txt_file>"
    echo "  ${Yellow}Multi file mode:${Color_Off} $0 <main_cpp> <user_cpp> <input_file>"
    exit 1
fi

# Run the compiled program
if [ ! -f ~/.tmp/run ]; 
    then
    echo "${Red}Build failed!${Color_Off}"
else
    echo "${Red}Build success. Console:${White}"
    ts=$(date +%s%N)
    ~/.tmp/run
    tt=$((($(date +%s%N) - $ts)/1000000))
    echo ""
    echo "${Red}Time: ${tt}ms${Color_Off}"
fi

# Clean up
rm -f ~/.tmp/$file_inpt
