INCLUDE Irvine32.inc

.data
    studentIDs DWORD 101, 102, 103, 104, 105, 95 DUP(0)        
    grades DWORD 85, 90, 78, 88, 95, 95 DUP(0)                
    maxStudents DWORD 100                         
    studentCount DWORD 5                           
    studentScores DWORD 100 dup(0)

menuMsg BYTE"                ########################################              ", 0Dh, 0Ah
        BYTE  "                    Student Management System                        ", 0Dh, 0Ah
        BYTE  "               ########################################              ", 0Dh, 0Ah
        BYTE  "                     1. View Students                                ", 0Dh, 0Ah
        BYTE  "                     2. Add New Student                               ", 0Dh, 0Ah
        BYTE  "                     3. Delete Student                                ", 0Dh, 0Ah
        BYTE  "                     4. Take Quiz                                     ", 0Dh, 0Ah
        BYTE  "                     5. Exit                                          ", 0Dh, 0Ah
        BYTE  "               ########################################                ", 0Dh, 0Ah, 0

choiceMsg BYTE "Enter your choice: ", 0
invalidMsg BYTE "Invalid choice. Try again.", 0Dh, 0Ah, 0
viewIDMsg BYTE "Student ID: ", 0
viewGradeMsg BYTE "Grade: ", 0
viewQuizMsg BYTE "Quiz Score: ", 0

newIDMsg BYTE "Enter new Student ID: ", 0
newGradeMsg BYTE "Enter grade for the new Student: ", 0
studentExistsMsg BYTE "Student ID already exists. Try again.", 0Dh, 0Ah, 0
deleteMsg BYTE "Enter Student ID to delete: ", 0
notFoundMsg BYTE "Student ID not found!", 0Dh, 0Ah, 0
successMsg BYTE "Student deleted successfully!", 0Dh, 0Ah, 0
cancelMsg BYTE "Deletion canceled.", 0

choice DWORD 0
studentID DWORD 0
newStudentID DWORD 0
newGrade DWORD 0

msg1 BYTE"|----------------------- Rules of the Quiz --------------------------------   |", 0Dh, 0Ah,0
msg2 BYTE"|                  BELOW MENTIONED SOME RULES                                 |", 0Dh, 0Ah,0
msg3 BYTE"| Rule 1: If your answer is correct you will get 1 point.                     |", 0Dh, 0Ah,0
msg4 BYTE"| Rule 2:If answer is wrong 1 point will be deducted from your points         |", 0Dh, 0Ah,0

msg6 BYTE "Good! Your answer is Right..", 0
msg7 BYTE "Ohh Sorry!! Wrong answer..", 0
msg8 BYTE "Your quiz has been completed", 0
msg9 BYTE "And here comes your total obtained scores: ", 0

Question1 BYTE "Q1) Which one of the following is not a primary color?:",0
QA1 BYTE "1) yellow 2) red  3) green 4) blue",0
Question2 BYTE "Q2) Which is the colour of sky",0
QA2 BYTE "1) violet 2) blue 3) black 4) red ",0
Question3 BYTE "Q3) Which of the following is not a natural number:",0
QA3 BYTE "1) 16 2) 32  3) 4  4) 0",0
Question4 BYTE "Q4) Which one of following has largest precedence:",0
QA4 BYTE "1) () 2) * 3) + 4) /",0
Question5 BYTE "Q5) How many alphabets are there in English:",0
QA5 BYTE "1) 22 2) 223 3) 23 4) 26",0

Points DWORD 0
Value DWORD ?

.code
main PROC
Start:
    CALL ShowMenu             
    MOV eax, choice
    CALL Crlf
    CMP eax, 1
    JE ViewStudents
    CMP eax, 2
    JE AddNewStudent
    CMP eax, 3
    JE DeleteStudent1
    CMP eax, 4
    JE Takequizz
    CMP eax, 5
    JE ExitProgram
    CALL InvalidChoice
    JMP Start 

ViewStudents:
    CALL DisplayStudents
    JMP Start

AddNewStudent:
    CALL AddStudent
    JMP Start

DeleteStudent1:
    CALL DeleteStudent
    JMP Start

Takequizz:
    CALL msg
    CALL Crlf
    CALL Crlf
    CALL game
    JMP Start

ExitProgram:
    MOV eax, 0
    RET
main ENDP

ShowMenu PROC
    MOV edx, OFFSET menuMsg
    CALL WriteString
    MOV edx, OFFSET choiceMsg
    CALL WriteString
    CALL ReadDec
    MOV choice, eax
    RET
ShowMenu ENDP

DisplayStudents PROC USES esi edi
    MOV esi, OFFSET studentIDs     
    MOV edi, OFFSET grades          
    MOV ebx, OFFSET studentScores
    MOV ecx, studentCount         
DisplayLoop:
    CMP ecx, 0                     
    JZ EndDisplay                   
    MOV eax, [esi]                  
    MOV edx, OFFSET viewIDMsg
    CALL WriteString                
    CALL WriteDec                  
    CALL Crlf                       
    MOV eax, [edi]                  
    MOV edx, OFFSET viewGradeMsg
    CALL WriteString               
    CALL WriteDec                   
    CALL Crlf                      
    MOV eax, [ebx]                  
    MOV edx, OFFSET viewQuizMsg
    CALL WriteString                
    CALL WriteDec                   
    CALL Crlf                       
    ADD esi, 4                      
    ADD edi, 4                      
    ADD ebx, 4                     
    CALL Crlf
    LOOP DisplayLoop                
EndDisplay:
    RET
DisplayStudents ENDP

AddStudent PROC USES esi
    MOV edx, OFFSET newIDMsg
    CALL WriteString
    CALL ReadDec
    MOV newStudentID, eax
    MOV esi, OFFSET studentIDs
    MOV ecx, studentCount
CheckIDLoop:
    MOV eax, [esi]
    CMP eax, newStudentID
    JE StudentIDExists
    ADD esi, 4
    LOOP CheckIDLoop
    MOV edx, OFFSET newGradeMsg
    CALL WriteString
    CALL ReadDec
    MOV newGrade, eax
    MOV ebx, studentCount
    IMUL ebx, 4
    MOV esi, OFFSET studentIDs
    ADD esi, ebx
    MOV eax, newStudentID
    MOV [esi], eax
    MOV esi, OFFSET grades
    ADD esi, ebx
    MOV eax, newGrade
    MOV [esi], eax
    INC studentCount
    RET
StudentIDExists:
    MOV edx, OFFSET studentExistsMsg 
    CALL WriteString
    RET
AddStudent ENDP

DeleteStudent PROC
    LOCAL foundIndex:DWORD 
    LOCAL confirmDelete:DWORD 
    MOV foundIndex, -1
    MOV edx, OFFSET deleteMsg
    CALL WriteString
    CALL ReadDec
    MOV studentID, eax 
    PUSH esi
    MOV esi, OFFSET studentIDs
    MOV ecx, studentCount
    XOR ebx, ebx 
SearchLoop:
    MOV eax, [esi]
    CMP eax, studentID
    JE FoundStudent
    ADD esi, 4
    INC ebx
    LOOP SearchLoop
    JMP StudentNotFound
FoundStudent:
    MOV foundIndex, ebx
    MOV esi, OFFSET studentIDs
    MOV edi, OFFSET grades
    MOV ebx, OFFSET studentScores
    MOV ecx, studentCount
    DEC ecx
    MOV eax, foundIndex
    IMUL eax, 4
    ADD esi, eax
    ADD edi, eax
ShiftLoop:
    CMP foundIndex, ecx
    JGE LastElement
    MOV eax, [esi+4]
    MOV [esi], eax
    MOV eax, [edi+4]
    MOV [edi], eax
    MOV eax, [ebx+4]
    MOV [ebx], eax
    ADD ebx, 4
    ADD esi, 4
    ADD edi, 4
    INC foundIndex
    JMP ShiftLoop
LastElement:
    MOV eax, 0
    MOV [esi], eax
    MOV [edi], eax
    MOV [ebx], eax
    DEC studentCount
    MOV edx, OFFSET successMsg
    CALL WriteString
    JMP DeleteEnd
StudentNotFound:
    MOV edx, OFFSET notFoundMsg
    CALL WriteString
DeleteEnd:
    POP esi
    RET
DeleteStudent ENDP

InvalidChoice PROC
    MOV edx, OFFSET invalidMsg
    CALL WriteString
    RET
InvalidChoice ENDP

UpdateStudentScore PROC
    MOV eax, studentID
    CMP eax, 0
    JL InvalidID
    CMP eax, studentCount
    JGE InvalidID
    MOV ebx, OFFSET studentScores
    IMUL eax, 4
    ADD ebx, eax
    MOV eax, Points  
    MOV [ebx], eax  
    RET
InvalidID:
    MOV edx, OFFSET invalidMsg
    CALL WriteString
    RET
UpdateStudentScore ENDP

msg PROC
    MOV edx, OFFSET msg1
    CALL WriteString 
    CALL Crlf
    MOV edx, OFFSET msg2
    CALL WriteString 
    CALL Crlf
    MOV edx, OFFSET msg3
    CALL WriteString
    CALL Crlf
    MOV edx, OFFSET msg4
    CALL WriteString 
    CALL Crlf
    RET
msg ENDP

game PROC USES esi 
    MOV edx, OFFSET viewIDMsg
    CALL WriteString
    CALL ReadDec
    MOV studentID, eax
    MOV esi, OFFSET studentIDs
    MOV ecx, studentCount
CheckIDLoop:
    MOV eax, [esi] 
    CMP eax, studentID 
    JE StudentIDExists2
    ADD esi, 4 
    LOOP CheckIDLoop 
    MOV edx, OFFSET notFoundMsg
    CALL WriteString
    RET
StudentIDExists2:
    MOV eax, studentCount
    SUB eax, ecx
    MOV studentID, eax
    MOV Points, 0

    ; Question 1
    MOV edx, OFFSET Question1
    CALL WriteString
    CALL Crlf
    MOV edx, OFFSET QA1
    CALL WriteString
    CALL Crlf
    CALL ReadInt
    CMP eax, 1
    JE CorrectAnswer1
    JMP IncorrectAnswer1
CorrectAnswer1:
    INC Points
    MOV edx, OFFSET msg6
    CALL WriteString
    JMP NextQuestion1
IncorrectAnswer1:
    MOV edx, OFFSET msg7
    CALL WriteString
NextQuestion1:
    CALL Crlf
    CALL Crlf

    ; Question 2
    MOV edx, OFFSET Question2
    CALL WriteString
    CALL Crlf
    MOV edx, OFFSET QA2
    CALL WriteString
    CALL Crlf
    CALL ReadInt
    CMP eax, 2
    JE CorrectAnswer2
    JMP IncorrectAnswer2
CorrectAnswer2:
    INC Points
    MOV edx, OFFSET msg6
    CALL WriteString
    JMP NextQuestion2
IncorrectAnswer2:
    MOV edx, OFFSET msg7
    CALL WriteString
NextQuestion2:
    CALL Crlf
    CALL Crlf

    ; Question 3
    MOV edx, OFFSET Question3
    CALL WriteString
    CALL Crlf
    MOV edx, OFFSET QA3
    CALL WriteString
    CALL Crlf
    CALL ReadInt
    CMP eax, 4
    JE CorrectAnswer3
    JMP IncorrectAnswer3
CorrectAnswer3:
    INC Points
    MOV edx, OFFSET msg6
    CALL WriteString
    JMP NextQuestion3
IncorrectAnswer3:
    MOV edx, OFFSET msg7
    CALL WriteString
NextQuestion3:
    CALL Crlf
    CALL Crlf

    ; Question 4
    MOV edx, OFFSET Question4
    CALL WriteString
    CALL Crlf
    MOV edx, OFFSET QA4
    CALL WriteString
    CALL Crlf
    CALL ReadInt
    CMP eax, 1
    JE CorrectAnswer4
    JMP IncorrectAnswer4
CorrectAnswer4:
    INC Points
    MOV edx, OFFSET msg6
    CALL WriteString
    JMP NextQuestion4
IncorrectAnswer4:
    MOV edx, OFFSET msg7
    CALL WriteString
NextQuestion4:
    CALL Crlf
    CALL Crlf

    ; Question 5
    MOV edx, OFFSET Question5
    CALL WriteString
    CALL Crlf
    MOV edx, OFFSET QA5
    CALL WriteString
    CALL Crlf
    CALL ReadInt
    CMP eax, 4
    JE CorrectAnswer5
    JMP IncorrectAnswer5
CorrectAnswer5:
    INC Points
    MOV edx, OFFSET msg6
    CALL WriteString
    JMP DisplayResult
IncorrectAnswer5:
    MOV edx, OFFSET msg7
    CALL WriteString

DisplayResult:
    CALL Crlf
    CALL Crlf
    MOV edx, OFFSET msg8
    CALL WriteString
    CALL Crlf
    MOV edx, OFFSET msg9
    CALL WriteString
    MOV eax, Points
    CALL WriteInt
    CALL Crlf
    CALL UpdateStudentScore
    MOV Points, 0
    RET
game ENDP

END main
