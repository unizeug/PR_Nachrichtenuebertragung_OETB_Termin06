/****************************************************************************
 *
 * Filename:    ps3000.h
 * Copyright:   Pico Technology Limited 2002-2007
 * Author:      MTB
 * Description:
 *
 * This header defines the interface to driver routines for the 
 *	PicoScope 3000 range of PC Oscilloscopes.
 *
 ****************************************************************************/

#ifndef PS3000_H
#define PS3000_H

#ifdef PREF0
  #undef PREF0
#endif
#ifdef PREF1
  #undef PREF1
#endif
#ifdef PREF2
  #undef PREF2
#endif
#ifdef PREF3
  #undef PREF3
#endif
#ifdef PREF4
  #undef PREF4
#endif

#ifdef __cplusplus
	#define PREF0 extern "C"
#else
	#define PREF0
#endif

/*	If you are dynamically linking PS3000.DLL into your project #define DYNLINK here
 */
#ifdef WIN32
	#ifdef DYNLINK
		#define PREF1 typedef
		#define PREF2
		#define PREF3(x) (__stdcall *x)
	#else
	  #define PREF1
		#ifdef _USRDLL
			#define PREF2 __declspec(dllexport) __stdcall
		#else
			#define PREF2 __declspec(dllimport) __stdcall
		#endif
	  #define PREF3(x) x
	#endif
	#define PREF4 __stdcall
#else
	#ifdef DYNLINK
		#define PREF1 typedef
		#define PREF2
		#define PREF3(x) (*x)
	#else
		#ifdef _USRDLL
			#define PREF1 __attribute__((visibility("default")))
		#else
			#define PREF1
		#endif
		#define PREF2
		#define PREF3(x) x
	#endif
	#define PREF4
#endif

#define PS3000_FIRST_USB  1
#if defined (_DEBUG)
#define PS3000_LAST_USB   64
#else
#define PS3000_LAST_USB 127
#endif

/* Maximum number of PS3000 units that can be opened at once
 */
#define PS3000_MAX_UNITS (PS3000_LAST_USB - PS3000_FIRST_USB + 1)

#define PS3206_MAX_TIMEBASE  21
#define PS3205_MAX_TIMEBASE  20
#define PS3204_MAX_TIMEBASE  19
#define PS3224_MAX_TIMEBASE  19
#define PS3223_MAX_TIMEBASE  19
#define PS3424_MAX_TIMEBASE  19
#define PS3423_MAX_TIMEBASE  19

#define PS3225_MAX_TIMEBASE  18
#define PS3226_MAX_TIMEBASE  19
#define PS3425_MAX_TIMEBASE  19
#define PS3426_MAX_TIMEBASE  19

#define PS3000_MAX_OVERSAMPLE 256

/* Although the PS3000 uses an 8-bit ADC, it is usually possible to
 * oversample (collect multiple readings at each time) by up to 256.
 * the results are therefore ALWAYS scaled up to 16-bits, even if
 * oversampling is not used.
 *
 * The maximum and minimum values returned are therefore as follows:
 */

#define PS3000_MAX_VALUE 32767
#define PS3000_MIN_VALUE -32767
#define PS3000_LOST_DATA -32768

/*
 * Signal generator constants. Note that a signal generator is not
 * available on all variants.
 */
#define PS3000_MIN_SIGGEN_FREQ	0.093
#define PS3000_MAX_SIGGEN_FREQ	1000000L

/*
 * ETS constants 
 */
#define PS3206_MAX_ETS_CYCLES	500
#define PS3206_MAX_ETS_INTERLEAVE	100

#define PS3205_MAX_ETS_CYCLES	250
#define PS3205_MAX_ETS_INTERLEAVE	50

#define PS3204_MAX_ETS_CYCLES	125
#define PS3204_MAX_ETS_INTERLEAVE	25

#define PS3000_MAX_ETS_CYCLES_INTERLEAVE_RATIO	10
#define PS3000_MIN_ETS_CYCLES_INTERLEAVE_RATIO	1
#define PS300_MAX_ETS_SAMPLES 100000

#define MAX_PULSE_WIDTH_QUALIFIER_COUNT 16777215L
#define MAX_HOLDOFF_COUNT 8388607L

typedef enum enPS3000Channel
{
	PS3000_CHANNEL_A,
	PS3000_CHANNEL_B,
	PS3000_CHANNEL_C,
	PS3000_CHANNEL_D,
	PS3000_EXTERNAL,
	PS3000_MAX_CHANNELS = PS3000_EXTERNAL,
	PS3000_NONE,
	PS3000_MAX_TRIGGER_SOURCES
}	PS3000_CHANNEL;

typedef enum enPS3000Range
{
	PS3000_10MV,
	PS3000_20MV,
	PS3000_50MV,
	PS3000_100MV,
	PS3000_200MV,
	PS3000_500MV,
	PS3000_1V,
	PS3000_2V,
	PS3000_5V,
	PS3000_10V,
	PS3000_20V,
  PS3000_50V,
  PS3000_100V,
  PS3000_200V,
  PS3000_400V,
	PS3000_MAX_RANGES
}	PS3000_RANGE;

typedef enum enPS3000WaveTypes
  {
  PS3000_SQUARE,
  PS3000_TRIANGLE,
  PS3000_SINE,
  PS3000_MAX_WAVE_TYPES
  }	PS3000_WAVE_TYPES;

typedef enum enPS3000TimeUnits
  {
  PS3000_FS,
  PS3000_PS,
  PS3000_NS,
  PS3000_US,
  PS3000_MS,
  PS3000_S,
  PS3000_MAX_TIME_UNITS,
  }	PS3000_TIME_UNITS;

typedef enum enPS3000Error
  {
  PS3000_OK,
  PS3000_MAX_UNITS_OPENED,	// more than PS3000_MAX_UNITS
  PS3000_MEM_FAIL,			//not enough RAM on host machine
  PS3000_NOT_FOUND,			//cannot find device
  PS3000_FW_FAIL,			//unabled to download firmware 
  PS3000_NOT_RESPONDING,
  PS3000_CONFIG_FAIL,		//missing or corrupted configuration settings
  PS3000_OS_NOT_SUPPORTED,	//need to use win98SE (or later) or win2k (or later)
  PS3000_PICOPP_TOO_OLD,
  }	PS3000_ERROR;

typedef enum enPS3000Info
{
	PS3000_DRIVER_VERSION,
	PS3000_USB_VERSION,
	PS3000_HARDWARE_VERSION,
	PS3000_VARIANT_INFO,
	PS3000_BATCH_AND_SERIAL,
	PS3000_CAL_DATE,
	PS3000_ERROR_CODE,
  PS3000_KERNEL_DRIVER_VERSION,
}	PS3000_INFO;

typedef enum enPS3000TriggerDirection
  {
  PS3000_RISING,
  PS3000_FALLING,
  PS3000_MAX_DIRS
  }	PS3000_TDIR;

typedef enum enPS3000OpenProgress
  {
  PS3000_OPEN_PROGRESS_FAIL     = -1,
  PS3000_OPEN_PROGRESS_PENDING  = 0,
  PS3000_OPEN_PROGRESS_COMPLETE = 1
  } PS3000_OPEN_PROGRESS;

typedef enum enPS3000EtsMode
  {
  PS3000_ETS_OFF,                        // ETS disabled
  PS3000_ETS_FAST,                       // Return ready as soon as requested no of interleaves is available
  PS3000_ETS_SLOW,                        // Return ready every time a new set of no_of_cycles is collected
  PS3000_ETS_MODES_MAX
  }	PS3000_ETS_MODE;

typedef short (PREF4 *PS3000_CALLBACK_FUNC) (short *dataBuffer, short noOfBuffers);


typedef void (PREF4 *GetOverviewBuffersMaxMin)(
  short **overviewBuffers,
  short overflow,
  unsigned long triggeredAt,
  short triggered,
  short auto_stop,
  unsigned long nValues);

PREF0 PREF1 short PREF2 PREF3(ps3000_open_unit)	 ( void );

PREF0 PREF1 short PREF2 PREF3(ps3000_get_unit_info) (
                                        short handle,
                                        char * string,
                                        short string_length,
                                        short line);

PREF0 PREF1 short PREF2 PREF3(ps3000_flash_led)	 ( short handle );

PREF0 PREF1 short PREF2 PREF3(ps3000_close_unit) ( short handle );

PREF0 PREF1 short PREF2 PREF3(ps3000_set_channel) (
									  short handle,
                                      short	channel,
                                      short	enabled,
                                      short	dc,
                                      short	range);

PREF0 PREF1 short PREF2 PREF3(ps3000_get_timebase) (
									   short handle,
									   short  timebase,
									   long   no_of_samples,
									   long  * time_interval,
									   short * time_units,
									   short	oversample,
                     long * max_samples);

PREF0 PREF1 long PREF2 PREF3(ps3000_set_siggen) (
									short handle,
									short wave_type,
									long start_frequency,
									long stop_frequency,
									float	increment,
									short	dwell_time,
									short	repeat,
									short	dual_slope);

PREF0 PREF1 long PREF2 PREF3(ps3000_set_ets) (
								 short handle,
								 short mode,
								 short ets_cycles,
								 short ets_interleave);

PREF0 PREF1 short PREF2 PREF3(ps3000_set_trigger) (
									  short handle,
									 short	source,
									 short	threshold,
									 short	direction,
									 short	delay,
									 short  auto_trigger_ms);

PREF0 PREF1 short PREF2 PREF3(ps3000_set_trigger2) (
									  short handle,
									  short	source,
									  short	threshold,
									  short	direction,
									  float	delay,
									  short  auto_trigger_ms);

PREF0 PREF1 short PREF2 PREF3(ps3000_run_block) (
									  short handle,
								    long	no_of_values,
								    short	timebase,
								    short	oversample,
								    long * time_indisposed_ms);


PREF0 PREF1 short PREF2 PREF3(ps3000_run_streaming_ns) (
										short handle,
                    unsigned long sample_interval,
										PS3000_TIME_UNITS time_units,
										unsigned long max_samples,
										short auto_stop,
										unsigned long noOfSamplesPerAggregate,
										unsigned long overview_buffer_size);

PREF0 PREF1 short PREF2 PREF3(ps3000_run_streaming) (
										short handle,
                    short sample_interval_ms,
                    long max_samples, 
                    short windowed);

PREF0 PREF1 short PREF2 PREF3(ps3000_ready) ( short handle );

PREF0 PREF1 short PREF2 PREF3(ps3000_stop) ( short handle );

PREF0 PREF1 long PREF2 PREF3(ps3000_get_values) (
									short handle,
									short * buffer_a,
									short * buffer_b,
									short * buffer_c,
									short * buffer_d,
									short * overflow,
									long no_of_values);

PREF0 PREF1 void PREF2 PREF3 (ps3000_release_stream_buffer) (short handle);

PREF0 PREF1 long PREF2 PREF3(ps3000_get_times_and_values) (
	short handle,
	long  * times,
	short * buffer_a,
	short * buffer_b,
	short * buffer_c,
	short * buffer_d,
	short * overflow,
	short time_units,
	long no_of_values);

PREF0 PREF1 short PREF2 PREF3(ps3000_open_unit_async) (void);
PREF0 PREF1 short PREF2 PREF3(ps3000_open_unit_progress) ( short * handle, short * progress_percent );

PREF0 PREF1 short PREF2 PREF3(ps3000_streaming_ns_get_interval_stateless) ( short handle, short nChannels, unsigned long * sample_interval);

PREF0 PREF1 short PREF2 PREF3(ps3000_get_streaming_last_values) (
	short handle,
  GetOverviewBuffersMaxMin lpGetOverviewBuffersMaxMin);

PREF0 PREF1 short PREF2 PREF3 (ps3000_overview_buffer_status)(
	short handle, 
	short * previous_buffer_overrun);

PREF0 PREF1 unsigned long PREF2 PREF3(ps3000_get_streaming_values) (
	short handle,
	double *start_time,
	short * pbuffer_a_max,
	short * pbuffer_a_min,
	short * pbuffer_b_max,
  short * pbuffer_b_min,
	short * pbuffer_c_max,
	short * pbuffer_c_min,
	short * pbuffer_d_max,
	short * pbuffer_d_min,
  short * overflow,
	unsigned long * triggerAt,
	short * triggered,
	unsigned long no_of_values,
	unsigned long noOfSamplesPerAggregate
	);

PREF0 PREF1 unsigned long PREF2 PREF3 (ps3000_get_streaming_values_no_aggregation)(
	short handle,
	double *start_time,
	short * pbuffer_a,
	short * pbuffer_b,
	short * pbuffer_c,
	short * pbuffer_d,
  short * overflow,
	unsigned long * triggerAt,
	short * trigger,
  unsigned long no_of_values);


PREF0 PREF1 short PREF2 PREF3 (ps3000_save_streaming_data) (
	short handle,
	PS3000_CALLBACK_FUNC lpCallbackFunc,
	short *dataBuffers,
	short dataBufferSize);

//===========================================================
// Adv Trigger stuff
//===========================================================
typedef enum enThresholdDirection
{
	ABOVE,
	BELOW,
	RISING,
	FALLING,
	RISING_OR_FALLING,
	INSIDE = ABOVE,
	OUTSIDE = BELOW,
	ENTER = RISING,
	EXIT = FALLING,
	ENTER_OR_EXIT = RISING_OR_FALLING,
  NONE = RISING
} THRESHOLD_DIRECTION;

typedef enum enThresholdMode
{
	LEVEL,
	WINDOW
} THRESHOLD_MODE;

typedef enum enTriggerState
{
  CONDITION_DONT_CARE,
  CONDITION_TRUE,
  CONDITION_FALSE,
	CONDITION_MAX
} TRIGGER_STATE;

typedef enum enPulseWidthType
{
	PW_TYPE_NONE,
  PW_TYPE_LESS_THAN,
	PW_TYPE_GREATER_THAN,
	PW_TYPE_IN_RANGE,
	PW_TYPE_OUT_OF_RANGE
} PULSE_WIDTH_TYPE;

#pragma pack(1)
typedef struct tTriggerChannelProperties
{
  short thresholdMajor;
  short thresholdMinor;
  unsigned short hysteresis;  
  short channel;
  THRESHOLD_MODE thresholdMode;
} TRIGGER_CHANNEL_PROPERTIES;
#pragma pack()

#pragma pack(1)
typedef struct tTriggerConditions
{
  TRIGGER_STATE channelA;
  TRIGGER_STATE channelB;
  TRIGGER_STATE channelC;
  TRIGGER_STATE channelD;
  TRIGGER_STATE external;
	TRIGGER_STATE pulseWidthQualifier;
} TRIGGER_CONDITIONS;
#pragma pack()

#pragma pack(1)
typedef struct tPwqConditions
{
  TRIGGER_STATE channelA;
  TRIGGER_STATE channelB;
  TRIGGER_STATE channelC;
  TRIGGER_STATE channelD;
  TRIGGER_STATE external;
} PWQ_CONDITIONS;
#pragma pack()

PREF0 PREF1 short PREF2 PREF3 (ps3000SetAdvTriggerChannelProperties)
	(
		short																handle,
		TRIGGER_CHANNEL_PROPERTIES *	channelProperties,
		short																nChannelProperties,
		long																autoTriggerMilliseconds
	);


PREF0 PREF1 short PREF2 PREF3 (ps3000SetAdvTriggerChannelConditions)
	(
		short									handle,
		TRIGGER_CONDITIONS	*	conditions,
		short									nConditions
	);

PREF0 PREF1 short PREF2 PREF3 (ps3000SetAdvTriggerChannelDirections)
	(
		short								handle,
		THRESHOLD_DIRECTION	channelA,
		THRESHOLD_DIRECTION	channelB,
		THRESHOLD_DIRECTION	channelC,
		THRESHOLD_DIRECTION	channelD,
		THRESHOLD_DIRECTION	ext
	);

PREF0 PREF1 short PREF2 PREF3 (ps3000SetPulseWidthQualifier)
	(
		short										handle,
		PWQ_CONDITIONS		*	conditions,
		short										nConditions,
		THRESHOLD_DIRECTION		  direction,
		unsigned long						lower,
		unsigned long						upper,
		PULSE_WIDTH_TYPE				type
	);
PREF0 PREF1 short PREF2 PREF3 (ps3000SetAdvTriggerDelay)
  (
  short					handle,
  unsigned long	delay,
  float preTriggerDelay
  );

PREF0 PREF1 short PREF2 PREF3 (ps3000PingUnit)
  (
  short					handle
  );

#endif /* not defined PS3000_H */
