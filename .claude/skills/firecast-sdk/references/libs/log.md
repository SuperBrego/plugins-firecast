# Biblioteca log

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Log library

       The Log library provides functions for emmiting log messages, which can be helpful to
       developers. All of these functions are contained in the “Log” Lua table found in the “log.lua” unit.
       Usage example:

    -- First, you need to use the “log.lua” unit
    require("log.lua");

    -- Now you can access the functions of the library.
    Log.LIBRARY_FUNCTION(Argument1, Argument2, ...);

Where the log messages goes to?

  The log messages emmited by this library are sent to:
                                 ○ The Firecast's console. Use the /console command to reveal the
                                      console.
                                 ○ The Firecast's debug log files (also known as "LogErrors")

Log library functions
function Log.e(tag, msg)
function Log.w(tag, msg)
function Log.i(tag, msg)
function Log.d(tag, msg)
function Log.v(tag, msg)

Emmit log message

Arguments:

                         ○ tag - Used to identify the source of a log message. It usually identifies
                               the location or activity where the log call occurs.

                         ○ msg - The message you would like to be logged

Log severity:

Log.  Error message

e     A situation that represents an unhandled error that may interrupt

      some operation

Log.  Warning message

w     A situation that can be handled but may cause some unintended

      behavior

Log.  Informational/Notice message

i     A normal but significant condition that may require special handling.

Log.  Debug message

d     A developer debug message

Log.  Verbose message

v     Algorithm steps message, very low priority messages.

      Remarks:

                          ● Messages of this severity are not emitted in the
                               Firecast’s log files

                          ● In the Firecast’s console, you need to execute the
                               command “filter add *” to be able to see these messages.
```
