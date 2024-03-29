/* Automatically generated nanopb header */
/* Generated by nanopb-0.4.6 */

#ifndef PB_MESSAGE_PB_H_INCLUDED
#define PB_MESSAGE_PB_H_INCLUDED
#include <pb.h>

#if PB_PROTO_HEADER_VERSION != 40
#error Regenerate this file with the current version of nanopb generator.
#endif

/* Struct definitions */
typedef struct _MotorStatus { 
    pb_callback_t status;
} MotorStatus;

typedef struct _MoveMotorCommand { 
    int32_t target;
} MoveMotorCommand;

typedef struct _ProgressCommand { 
    float progress;
} ProgressCommand;

typedef struct _ResetMotorPositionCommand { 
    int32_t motorIndex;
} ResetMotorPositionCommand;

typedef struct _Command { 
    pb_size_t which_msg;
    union {
        ProgressCommand progress;
        MoveMotorCommand move;
        ResetMotorPositionCommand reset;
    } msg;
} Command;


#ifdef __cplusplus
extern "C" {
#endif

/* Initializer values for message structs */
#define Command_init_default                     {0, {ProgressCommand_init_default}}
#define ProgressCommand_init_default             {0}
#define MoveMotorCommand_init_default            {0}
#define ResetMotorPositionCommand_init_default   {0}
#define MotorStatus_init_default                 {{{NULL}, NULL}}
#define Command_init_zero                        {0, {ProgressCommand_init_zero}}
#define ProgressCommand_init_zero                {0}
#define MoveMotorCommand_init_zero               {0}
#define ResetMotorPositionCommand_init_zero      {0}
#define MotorStatus_init_zero                    {{{NULL}, NULL}}

/* Field tags (for use in manual encoding/decoding) */
#define MotorStatus_status_tag                   1
#define MoveMotorCommand_target_tag              1
#define ProgressCommand_progress_tag             1
#define ResetMotorPositionCommand_motorIndex_tag 1
#define Command_progress_tag                     1
#define Command_move_tag                         2
#define Command_reset_tag                        3

/* Struct field encoding specification for nanopb */
#define Command_FIELDLIST(X, a) \
X(a, STATIC,   ONEOF,    MESSAGE,  (msg,progress,msg.progress),   1) \
X(a, STATIC,   ONEOF,    MESSAGE,  (msg,move,msg.move),   2) \
X(a, STATIC,   ONEOF,    MESSAGE,  (msg,reset,msg.reset),   3)
#define Command_CALLBACK NULL
#define Command_DEFAULT NULL
#define Command_msg_progress_MSGTYPE ProgressCommand
#define Command_msg_move_MSGTYPE MoveMotorCommand
#define Command_msg_reset_MSGTYPE ResetMotorPositionCommand

#define ProgressCommand_FIELDLIST(X, a) \
X(a, STATIC,   SINGULAR, FLOAT,    progress,          1)
#define ProgressCommand_CALLBACK NULL
#define ProgressCommand_DEFAULT NULL

#define MoveMotorCommand_FIELDLIST(X, a) \
X(a, STATIC,   SINGULAR, INT32,    target,            1)
#define MoveMotorCommand_CALLBACK NULL
#define MoveMotorCommand_DEFAULT NULL

#define ResetMotorPositionCommand_FIELDLIST(X, a) \
X(a, STATIC,   SINGULAR, INT32,    motorIndex,        1)
#define ResetMotorPositionCommand_CALLBACK NULL
#define ResetMotorPositionCommand_DEFAULT NULL

#define MotorStatus_FIELDLIST(X, a) \
X(a, CALLBACK, REPEATED, INT32,    status,            1)
#define MotorStatus_CALLBACK pb_default_field_callback
#define MotorStatus_DEFAULT NULL

extern const pb_msgdesc_t Command_msg;
extern const pb_msgdesc_t ProgressCommand_msg;
extern const pb_msgdesc_t MoveMotorCommand_msg;
extern const pb_msgdesc_t ResetMotorPositionCommand_msg;
extern const pb_msgdesc_t MotorStatus_msg;

/* Defines for backwards compatibility with code written before nanopb-0.4.0 */
#define Command_fields &Command_msg
#define ProgressCommand_fields &ProgressCommand_msg
#define MoveMotorCommand_fields &MoveMotorCommand_msg
#define ResetMotorPositionCommand_fields &ResetMotorPositionCommand_msg
#define MotorStatus_fields &MotorStatus_msg

/* Maximum encoded size of messages (where known) */
/* MotorStatus_size depends on runtime parameters */
#define Command_size                             13
#define MoveMotorCommand_size                    11
#define ProgressCommand_size                     5
#define ResetMotorPositionCommand_size           11

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif
