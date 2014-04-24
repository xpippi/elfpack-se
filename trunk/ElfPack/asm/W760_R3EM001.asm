//W760_R3EM001
#include "target.h"
        RSEG   CODE
        CODE32

defadr  MACRO   a,b
        PUBLIC  a
a       EQU     b
        ENDM

        RSEG  CODE
        defadr   STANDBY_RET,0x10E289D8+1
        defadr   DB_PATCH_RET,0x1186FA60+1
        defadr   DB_EXT_RET,0x1186F868+1
        defadr   DB_PATCH3_RET,0x1186F710+1
        defadr   DB_PATCH4_RET,0x118700DE+1
        defadr   DB_PATCH5_RET,0x1186F8B4+1
        defadr   DB_PATCH6_RET,0x1186F8E8+1
        defadr   MESS_HOOK_RET,0x112A9B54+1

        defadr  memalloc,0x4BB00584
        defadr  memfree,0x4BB005AC
        defadr  Timer_Set,0x10E8618D

// --- Patch Keyhandler ---
	EXTERN Keyhandler_Hook
	RSEG  PATCH_KEYHANDLER1
        RSEG  CODE
        CODE16
NEW_KEYHANDLER1:
	MOV	R3, R7
	PUSH	{R0,R1}
	LDRH	R0, [R4,#0]
	BLX	Keyhandler_Hook
	MOV	R2, SP
	STRH	R0, [R2,#0x14]
	MOV	R1, R0
	MOV	R0, R7
	LDR	R2, =SFE(PATCH_KEYHANDLER1)+1
	MOV	R12, R2
	POP	{R2,R3}
	BX	R12


	RSEG  PATCH_KEYHANDLER1
        CODE16
        LDR     R3,=NEW_KEYHANDLER1
        BX      R3


	RSEG  PATCH_KEYHANDLER1_STACK1(1)
        CODE16
	SUB	SP, #0x10


	RSEG  PATCH_KEYHANDLER1_STACK2(1)
        CODE16
	ADD	SP, #0x10


	RSEG  PATCH_KEYHANDLER1_CHANGE1(1)
        CODE16
	MOV	R0, SP
	LDRH	R1, [R0,#0x14]


	RSEG  PATCH_KEYHANDLER1_CHANGE2(1)
        CODE16
	MOV	R0, SP
	LDRH	R1, [R0,#0x10]


	RSEG  PATCH_KEYHANDLER1_CHANGE3(1)
        CODE16
	MOV	R3, SP
	LDRH	R2, [R3,#0xC]


	RSEG  PATCH_KEYHANDLER1_CHANGE4(1)
        CODE16
	MOV	R3, SP
	LDRH	R0, [R3,#0xC]


	RSEG  PATCH_KEYHANDLER2
        RSEG  CODE
        CODE16
NEW_KEYHANDLER2:
	MOV	R3, R6
	MOV	R7, R0
	MOV	R2, R0
	MOV	R1, #0x0
	MOV	R0, R4
	BLX	Keyhandler_Hook
	MOV	R4, R0
	MOV	R2, R7
	MOV	R3, #0x0
	MOV	R1, R4
	MOV	R0, R6
	LDR	R7, =SFE(PATCH_KEYHANDLER2)+1
	BX	R7

	RSEG  PATCH_KEYHANDLER2
        CODE16
        LDR     R2,=NEW_KEYHANDLER2
        BX      R2


	RSEG  PATCH_KEYHANDLER3
        RSEG  CODE
        CODE16
NEW_KEYHANDLER3:
	MOV	R3, R6
	PUSH	{R0,R1}
	MOV	R2, R0
	LDRH	R0, [R7,#0x4]
	BLX	Keyhandler_Hook
	POP	{R2,R3}
	STRH	R0, [R7,#0x4]
	MOV	R1, R0
	LDR	R0, =SFE(PATCH_KEYHANDLER3)+1
	BX	R0

	RSEG  PATCH_KEYHANDLER3
        CODE16
        LDR     R3,=NEW_KEYHANDLER3
        BX      R3


	RSEG  PATCH_KEYHANDLER4
        RSEG  CODE
        CODE32
NEW_KEYHANDLER4:

	MOV	R2, R4
	BLX	Timer_Set
	STRH	R0, [R4,#16]
	LDRH	R0, [R4,#0]
	LDR	R1, =KEY_LAST
	CMP	R0, R1
	LDRNE	R0, =SFE(PATCH_KEYHANDLER4)+1
	BXNE	R0
	LDR	R0, =KEY_HOOK_TIMER_RETUN
	BX	R0


	RSEG  PATCH_KEYHANDLER4
        CODE16
        LDR     R2,=NEW_KEYHANDLER4
        BX      R2


// --- CreateLists ---

        EXTERN  CreateLists
        RSEG  CODE
        CODE16
PATCH_STANDBY:

        STR     R0, [R7,#0xC]
        STR     R0, [R7,#0x10]
        STR     R0, [R7,#0x14]
        STR     R0, [R7,#0x18]
        BLX     CreateLists
        MOV     R0, #0
        LDR     R5,=STANDBY_RET
        BX      R5

        RSEG  PATCH_STANDBY_CALL
        CODE16
        LDR     R5,=PATCH_STANDBY
        BX      R5


// --- ParseHelperMessage ---
        EXTERN  ParseHelperMessage
        RSEG   CODE
        CODE16
MESS_HOOK:
	MOV	R7, #1
        LDR     R5, [R6, #0]

        BLX     ParseHelperMessage
        LDR     R3, =MESS_HOOK_RET
        BX      R3

        RSEG   PATCH_MMI_MESSAGE_HOOK
        CODE16
        LDR     R7,=MESS_HOOK
        BX      R7

// --- PageAction1 ---
        EXTERN  PageAction_Hook2
        RSEG    PATCH_PageActionImpl_All
        RSEG   CODE
        CODE16
PG_ACTION:
	MOV	R2, R6
	MOV	R1, R5
	MOV	R0, R4
        BLX     PageAction_Hook2
        LDR     R4,=SFE(PATCH_PageActionImpl_All)+1
        BX      R4



        RSEG    PATCH_PageActionImpl_All
        CODE16
        LDR     R2, =PG_ACTION
        BX      R2


        EXTERN  PageAction_Hook2
        RSEG    PATCH_PageActionImpl_EnterExit
        RSEG   CODE
        CODE16
PG_ACTION2:
	LDR	R2, [SP,#0x1C]
	LDR	R1, [SP,#0x20]
	MOV	R0, R6
        BLX     PageAction_Hook2
        LDR     R7,=SFE(PATCH_PageActionImpl_EnterExit)+1
        BX      R7



        RSEG    PATCH_PageActionImpl_EnterExit
        CODE16
        LDR     R2, =PG_ACTION2
        BX      R2

// --- Data Browser ---

        EXTERN  GetExtTable
        RSEG   CODE
        CODE16
DB_PATCH:
        BLX     GetExtTable
        LSL     R1, R7, #2
        LDR     R0, [R0,R1]
        LDR     R1, =0x11ED5ED8
        LDR     R3, =DB_PATCH_RET
        BX      R3


        RSEG   CODE
        CODE16

DBEXT:

        BLX     GetExtTable
	LSL	R1, R5, #2
	LDR	R0, [R0,R1]
	LDR	R1, =0x11ED5ED8
	STR	R0, [SP,#0]
        LDR     R3, =DB_EXT_RET
        BX      R3

        RSEG   CODE
        CODE16

DB_PATCH3:
        BLX     GetExtTable
	LSL	R1, R5, #2
	LDR	R0, [R0,R1]
	LDR	R1, =0x11ED5ED8
	STR	R0, [SP,#0]
        LDR     R3, =DB_PATCH3_RET
        BX      R3


        RSEG   CODE
        CODE16

DB_PATCH4:
        BLX     GetExtTable
	LSL	R1, R6, #2
	LDR	R7, [R0,R1]
	LDR	R0, =0x11ED5ED8
        LDR     R1, =DB_PATCH4_RET
        BX      R1


        RSEG   CODE
        CODE16

DB_PATCH5:
        BLX     GetExtTable
	LSL	R1, R5, #2
	LDR	R1, [R0,R1]
	LSL	R0, R6, #2
        LDR     R7, =DB_PATCH5_RET
        BX      R7


        RSEG   CODE
        CODE16

DB_PATCH6:
        BLX     GetExtTable
	LSL	R1, R5, #2
	LDR	R1, [R0,R1]
	LSL	R0, R6, #2
        LDR     R2, =DB_PATCH6_RET
        BX      R2



        RSEG   PATCH_DB1(2)
        CODE16
        LDR    R3, =DB_PATCH
        BX     R3

        RSEG   PATCH_DB2(2)
        CODE16
        LDR    R3, =DBEXT
        BX     R3

        RSEG   PATCH_DB3(2)
        CODE16
        LDR    R3, =DB_PATCH3
        BX     R3

        RSEG   PATCH_DB4(2)
        CODE16
        LDR    R3, =DB_PATCH4
        BX     R3

        RSEG   PATCH_DB5(2)
        CODE16
        LDR    R2, =DB_PATCH5
        BX     R2

        RSEG   PATCH_DB6(2)
        CODE16
        LDR    R2, =DB_PATCH6
        BX     R2

        END
