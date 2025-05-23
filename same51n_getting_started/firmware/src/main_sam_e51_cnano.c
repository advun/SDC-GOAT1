/*******************************************************************************
  Main Source File

  Company:
  SDC
 * CAMERON WUZN'T HERE
 * OCTAVIO was here

  File Name:
    main.c

  Summary:
 Blink and not blink

  Description:
    This file contains the "main" function for a project.  The
    "main" function calls the "SYS_Initialize" function to initialize the state
    machines of all modules in the system
 *******************************************************************************/

#include <stdio.h>
#include <stddef.h>                     // Defines NULL
#include <stdbool.h>                    // Defines true
#include <stdlib.h>                     // Defines EXIT_FAILURE
#include <string.h>
#include "definitions.h"                // SYS function prototypes

/* RTC Time period match values for input clock of 1 KHz */
#define PERIOD_500MS                            512
#define PERIOD_1S                               1024
#define PERIOD_2S                               2048
#define PERIOD_4S                               4096

typedef enum
{
    TEMP_SAMPLING_RATE_500MS = 0,
    TEMP_SAMPLING_RATE_1S = 1,
    TEMP_SAMPLING_RATE_2S = 2,
    TEMP_SAMPLING_RATE_4S = 3,
} TEMP_SAMPLING_RATE;
static TEMP_SAMPLING_RATE tempSampleRate = TEMP_SAMPLING_RATE_500MS;
static const char timeouts[4][20] = {"500 milliSeconds", "1 Second",  "2 Seconds",  "4 Seconds"};

static volatile bool isRTCExpired = false;
static volatile bool changeTempSamplingRate = false;
static volatile bool isUSARTTxComplete = true;
static uint8_t uartTxBuffer[100] = {0};

static void EIC_User_Handler(uintptr_t context)
{
    changeTempSamplingRate = true;
}
static void rtcEventHandler (RTC_TIMER32_INT_MASK intCause, uintptr_t context)
{
    if (intCause & RTC_MODE0_INTENSET_CMP0_Msk)
    {            
        isRTCExpired    = true;
    }
}
static void usartDmaChannelHandler(DMAC_TRANSFER_EVENT event, uintptr_t contextHandle)
{
    if (event == DMAC_TRANSFER_EVENT_COMPLETE)
    {
        isUSARTTxComplete = true;
    }
}

// *****************************************************************************
// *****************************************************************************
// Section: Main Entry Point
// *****************************************************************************
// *****************************************************************************
int main ( void )
{
    uint8_t uartLocalTxBuffer[100] = {0};
    
    /* Initialize all modules */
    SYS_Initialize ( NULL );
    DMAC_ChannelCallbackRegister(DMAC_CHANNEL_0, usartDmaChannelHandler, 0);
    EIC_CallbackRegister(EIC_PIN_15,EIC_User_Handler, 0);
    RTC_Timer32CallbackRegister(rtcEventHandler, 0);
    
    sprintf((char*)uartTxBuffer, "Toggling LED at 500 milliseconds rate \r\n");
    RTC_Timer32Start();

    while ( true )
    {
        if ((isRTCExpired == true) && (true == isUSARTTxComplete))
        {
            isRTCExpired = false;
            isUSARTTxComplete = false;
            LED0_Toggle();
            DMAC_ChannelTransfer(DMAC_CHANNEL_0, uartTxBuffer, \
                    (const void *)&(SERCOM5_REGS->USART_INT.SERCOM_DATA), \
                    strlen((const char*)uartTxBuffer));
        }
        /* Maintain state machines of all polled MPLAB Harmony modules. */
        if(changeTempSamplingRate == true)
        {
            changeTempSamplingRate = false;
            if(tempSampleRate == TEMP_SAMPLING_RATE_500MS)
            {
                tempSampleRate = TEMP_SAMPLING_RATE_1S;
                RTC_Timer32Compare0Set(PERIOD_1S);
            }
            else if(tempSampleRate == TEMP_SAMPLING_RATE_1S)
            {
                tempSampleRate = TEMP_SAMPLING_RATE_2S;
                RTC_Timer32Compare0Set(PERIOD_2S);                        
            }
            else if(tempSampleRate == TEMP_SAMPLING_RATE_2S)
            {
                tempSampleRate = TEMP_SAMPLING_RATE_4S;
                RTC_Timer32Compare0Set(PERIOD_4S);                                        
            }    
            else if(tempSampleRate == TEMP_SAMPLING_RATE_4S)
            {
               tempSampleRate = TEMP_SAMPLING_RATE_500MS;
               RTC_Timer32Compare0Set(PERIOD_500MS);
            }
            else
            {
                ;
            }
            RTC_Timer32CounterSet(0);
            sprintf((char*)uartLocalTxBuffer, "LED Toggling rate is changed to %s\r\n", &timeouts[(uint8_t)tempSampleRate][0]);
            DMAC_ChannelTransfer(DMAC_CHANNEL_0, uartLocalTxBuffer, \
                    (const void *)&(SERCOM5_REGS->USART_INT.SERCOM_DATA), \
                    strlen((const char*)uartLocalTxBuffer));
            sprintf((char*)uartTxBuffer, "Toggling LED at %s rate \r\n", &timeouts[(uint8_t)tempSampleRate][0]);
        }
    }

    /* Execution should not come here during normal operation */

    return ( EXIT_FAILURE );
}
/*******************************************************************************
 End of File
 * 
 * 
 * 
 * 
 * #include "definitions.h" // SYS function prototypes

// ****************************************************************************
// Section: Main Entry Point
// ****************************************************************************

static volatile bool ledState = false;

static void EIC_User_Handler(uintptr_t context)
{
    ledState = true;
}

int main(void)
{
    // Initialize all modules
    SYS_Initialize(NULL);
    
    EIC_CallbackRegister(EIC_PIN_15,EIC_User_Handler, 2);
    
    while (true)
    {
        if (ledState) { // Toggle the LED
            LED0_Toggle();
            ledState = false;
        }
    }

    return 0;
}

*/



