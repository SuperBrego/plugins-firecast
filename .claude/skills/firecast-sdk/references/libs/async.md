# Biblioteca async

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Async library

       The Async library provides functions for handling asynchronous operations, such as loading a
       remote node database. All of these functions are contained in the “Async” Lua table found in the
       “async.lua” unit.
       Usage example:

    -- First, you need to require the “async.lua” unit
    require("async.lua");

    -- Now you can access the functions of the library.
    Async.LIBRARY_FUNCTION(Argument1, Argument2, ...);

Async library functions
function Async.await(promise)
function await(promise)

   Performs an asynchronous wait for the resolution of a Promise object, suspending the currently
   running coroutine until the provided Promise is resolved. While suspended, other coroutines
   and program execution lines can run, preventing the application from blocking or freezing. The
   coroutine execution is resumed once the given Promise is resolved to either success or failure

   Reminder: Coroutines are computer program execution lines that can be suspended and resumed.

   Arguments:

                             ○ promise - A Promise object identifying the promise for which the
                                  asynchronous wait must be performed

   Return:

       When the wait is complete:

                             ○ If the given promise resolves to success, the function returns the
                                  promise's success data.

                             ○ If the given promise resolves to failure, the function raises an error with
                                  the promise's failure message.

   Remarks:

                             ○ Using this function can significantly simplify your code when waiting for
                                  the outcome of promises.

                             ○ If the given promise has already been resolved, the await will return, or
                                  raise an error, if applicable, immediately, without suspending the
                                  execution of the current coroutine.

                             ○ Keep in mind that this function works only inside coroutines. All
                                  Firecast events run inside coroutines, but you can always start a
                                  coroutine with the Async.execute function.

                             ○ If you dont want automatic error raising in case the promise resolves to
                                  failure, check the similar function pawait.

function Async.execute(fn, ...)

   Starts the execution of a coroutine.

   Reminder: Coroutines are computer program execution lines that can be suspended and resumed.

   Arguments:

                             ○ fn - A function that will be executed by the coroutine.
                             ○ ... (variable argument list) - All given arguments will be passed to the

                                  function as arguments when it starts the execution.

   Return:
Remarks:  ○ A Promise object that can be used to track the execution of the
               coroutine. The success data of this promise will be whatever the given
               function returns during its execution. If an error occurs while executing
               the function, the promise will be resolved to failure with the failure
               message describing the execution error.

          ○ You can use the await function inside coroutines!
          ○ The coroutine starts its execution immediately. Calling Async.execute

               will return when the given function reaches its end, when an execution
               error occurs, or when it is first suspended (such as by calling `await`),
               whichever comes first.
          ○ If the given function returns a Promise object at the end of its
               execution, a delegation will occur, making the promise returned by
               Async.execute resolve when the mentioned Promise resolves, with the
               same outcome

function Async.pawait(promise)
function pawait(promise)

Similar to the await function, pawait performs an asynchronous wait for the resolution of a
Promise object, suspending the currently running coroutine until the provided Promise object
is resolved. However, unlike await, pawait does not automatically raise an error if the promise
resolves to failure

Arguments:

                         ○ promise - A Promise object identifying the promise for which the
                               asynchronous wait must be performed

Return:

    When the wait is complete, the function will return multiple values:

                         ○ f the given promise resolves to success, the first returned value will be a
                               boolean with the value true, and the second one will be the promise's
                               success data.

                         ○ If the given promise resolves to failure, the first returned value will be a
                               boolean with the value false, and the second one will be the promise's
                               failure message.

Remarks:

                         ○ For more information, please refer to the await function
                               documentation.
Async.Promise library

       The Async.Promise library provides functions for handling asynchronous operations, such as
       loading a remote node database. All of these functions are contained in the “Async.Promise”
       and/or “Promise” Lua tables found in the “async.lua” unit.
       Usage example:

    -- First, you need to require the “async.lua” unit
    require("async.lua");

    -- Now you can access the functions of the library.
    Async.Promise.LIBRARY_FUNCTION(Argument1, Argument2, ...);
    or
    Promise.LIBRARY_FUNCTION(Argument1, Argument2, ...);

Async.Promise library functions

    function Async.Promise.all(promise1[, promise2[, promise3[, ...
    promiseN]]])
    function Async.Promise.all(promisesArray)
    function Promise.all(promise1[, promise2[, promise3[, ...promiseN]]])
    function Promise.all(promisesArray)

       This function takes a set of Promise objects and creates a single Promise object that will be
       resolved when all provided promises are resolved. The set of Promise objects can be passed to
       this function using one of the following styles:
       Arguments (variable number of arguments style):

                                 ○ Each argument identifies a single Promise object in the set. Examples of
                                      valid usages:
                                                      ■ Promise.all(promise)
                                                      ■ Promise.all(promise, promise2)
                                                      ■ Promise.all(promise, promise2, promise3)
                                                      ■ Promise.all(promise, promise2, promise3, promise4)

       Arguments (array style):
                                 ○ promisesArray - A single array containing all Promise objects of the set.

       Return:
                                 ○ A newly created Promise object that monitors all informed Promise
                                      objects.
Remarks:

          ○ The returned Promise will be successfully resolved when all informed
               promises are successfully resolved. The success data of the returned

               Promise will be an array containing the set success data, in the order of

               the promises passed, regardless of completion order.
          ○ If any of the given Promises is resolved to failure, the promise returned

               by this function will also be resolved to failure, and its associated failure

               reason will be the same as the first promise that was resolved to failure.
          ○ If the given set of Promises is empty, the function will return an already

               resolved Promise object.

function Async.Promise.isPromise(value)
function Promise.isPromise(value)

Check is the provided value is a Promise object

Arguments:
                         ○ value - the value that will be verified.

Return:
                         ○ A boolean; true means the provided value is a promise object, false
                               otherwise.

function Async.Promise.resolved(data)
function Async.Promise.resolve(data)
function Async.Promise.succeeded(data)
function Promise.resolved(data)
function Promise.resolve(data)
function Promise.succeeded(data)

   Creates and returns a Promise object that has already been successfully resolved with the
   provided “data” argument
   Arguments:

                             ○ data - the value that was successfully resolved. This can be any
                                  information you want to pass as a successful return value

   Return:
                             ○ The new Promise object

function Async.Promise.toHandle(promise, successCallback,[, failureCallback])
function Promise.toHandle(promise, successCallback[, failureCallback])

   Creates a Promise object that receives the outcome of another existing Promise object and
   potentially returns converted data.

   Arguments:

                             ○ promise - An existing Promise object that will be monitored
                             ○ successCallback - A function called when the monitored Promise object

                                  resolves to success. The first argument received by this function is the
                                  outcome data of the monitored promise. Whatever this function
                                  returns will be the success data of the new promise.
                             ○ (Optional) failureCallback - A function called when the monitored
                                  Promise object resolves to failure. The first argument received by this
                                  function is the error message of the monitored promise. Whatever this
                                  function returns will be the success data of the new promise.

   Return:

                             ○ A new Promise object

   Remarks

                             ○ This type of promise is typically used to convert data from an
                                  asynchronous operation and/or to provide an alternate outcome if the
                                  monitored asynchronous operation fails.

                             ○ If the execution of `successCallback` raises an error or exception, the
                                  new promise will resolve to failure even if the monitored promise
                                  resolved to success.

                             ○ If the execution of `successCallback` returns a third promise object, the
                                  outcome of the promise created by this function will be delegated to
                                  this third promise.

                             ○ If the execution of `failureCallback` does not raise an error or
                                  exception, the new promise will resolve to success even if the
                                  monitored promise resolved to failure.

                             ○ If the execution of `failureCallback` returns a third promise object, the
                                  outcome of the promise created by this function will be delegated to
                                  this third promise.

function Async.Promise.toResolve()

function Async.Promise.pending()

function Promise.toResolve()

function Promise.pending()

   Creates a Promise object that is in a pending state and its associated Promise Resolution
   object.

   This function returns 2 values:
Remarks  ○ The first return is a new Promise object
         ○ The second return is the PromiseResolution object that is used to

              resolve the created Promise.

         ○ While the Promise object represents an asynchronous process that
              other pieces of code can track, the PromiseResolution object is used to
              resolve the promise either to success or failure. Typically, you return or
              pass along the Promise object as a mechanism to monitor the
              asynchronous operation while keeping and using the
              PromiseResolution privately.

function Async.Promise.withError(errorMsg)
function Async.Promise.withException(errorMsg)
function Async.Promise.failed(errorMsg)function
Async.Promise.reject(errorMsg)
function Promise.withError(errorMsg)
function Promise.withException(errorMsg)
function Promise.failed(errorMsg)
function Promise.reject(errorMsg)

Creates and returns a Promise object that has already been resolved with a failure state and
with the provided error message

Arguments:

                         ○ errorMsg - The error message that describes why the Promise resolved
                               to a failed state.

Return:

                         ○ The new Promise object

Promise object

  A Promise is an object designed for monitoring asynchronous operations and their eventual
  outcomes, whether they result in success or failure

  A Promise can exist in one of the following states:

                                 ○ Pending - The asynchronous operation is still in progress
                                 ○ Success - The asynchronous operation concluded successfully
                                 ○ Failed - The asynchronous operation concluded with an error or failure.

  Once a Promise has resolved to either "Success" or "Failed," its state becomes sealed along with its
  associated data or error message, and it remains immutable.
Tracking a promise
  When dealing with a function that returns a Promise object, you have the flexibility to either
  monitor or disregard its eventual outcome. If the success or failure of the asynchronous operation
  doesn't impact your code, you can simply ignore the Promise object.
  If you need to capture the result of an asynchronous operation, you can engage with the Promise
  object using one of the following styles:

"Await" style for tracking promises:
  This style simplifies the code, but it is limited to use within coroutines.
       Reminder: Coroutines are computer program execution lines that can be suspended and resumed.
       All Firecast events run inside coroutines, and you can initiate a new one using the Async.execute
       function.
       Example 1 (using a variable to hold the Promise object):

             local promise = Dialogs.asyncOpenFile("Select a image",
             "image/*");
             local selectedFiles = await(promise);
             showMessage(selectedFiles[1].name);

       Example 2 (without using a variable to hold the Promise object):

             local selectedFiles = await(Dialogs.asyncOpenFile("Select a
             image", "image/*"));
             showMessage(selectedFiles[1].name);

       Example 3 (using the sugar "await" method that Promises objects have):

             local selectedFiles = Dialogs.asyncOpenFile("Select a image",
             "image/*"):await();
             showMessage(selectedFiles[1].name);

      Please refer to the await function documentation for more details.

"Event" style for tracking promises:
  This style works both inside and outside of coroutines but can make your code less readable if used
  excessively.
  Invoke the "thenDo" and/or "onError" methods that all Promise objects have. The functionality of
  these methods is clarified below.
       Example 1 (using a variable to hold the Promise object):
    local promise = Dialogs.asyncOpenFile("Select a image",
    "image/*");

    promise:thenDo(
           function(selectedFiles)
                   -- the argument "selectedFiles" receives the success

    data of the promise
                   showMessage(selectedFiles[1].name);

    end);

Example 2 (without using a variable to hold the Promise object):

    Dialogs.asyncOpenFile("Select a image", "image/*"):thenDo(
           function(selectedFiles)
                   -- the argument "selectedFiles" receives the success

    data of the promise
                   showMessage(selectedFiles[1].name);

           end);

Object characteristics  Descrição
Methods
                        This method is employed to synchronize
   Método               with the resolution of the Promise,
   promise:await()      allowing your code to pause until the
                        asynchronous operation concludes.
   promise:pawait()
                        The promise:await() method is
                        functionally equivalent to await(promise).

                        For detailed information, please consult
                        the documentation for the await function.

                        This method is employed to synchronize
                        with the resolution of the Promise,
                        allowing your code to pause until the
                        asynchronous operation concludes.

                        The promise:pawait() method is
                        functionally equivalent to
                        pawait(promise)
promise:thenDo(successCallback)     For detailed information, please consult
or                                  the documentation for the pawait
promise:onSuccess(successCallback)  function.

                                    Set a continuation callback function that
                                    will be called when the Promise resolves
                                    to success.

                                    Arguments:

                                              ● successCallback - A function
                                                   that will be called when the
                                                   Promise resolves to success.
                                                   The first argument of the
                                                   callback function will receive
                                                   the associated success data.

                                    Return:

                                              ● A new Promise object that
                                                   will be resolved
                                                   asynchronously with the
                                                   execution of the
                                                   successCallback. This new
                                                   promise can be used to chain
                                                   promises handling.

                                    Remarks:

                                              ● If the Promise is already in a
                                                   success state, the
                                                   successCallback will be called
                                                   as soon as possible

                                    Example:

                                    1. local promise =

                                        Firecast.asyncOpenUser

                                        NDB("name");

                                    2.

                                    3. promise:thenDo(

                                    4.  function(node)

                                    5.  -- This

                                        function will be

                                        called when the

                                        Promise is resolved

                                        --

                                        successfully. The

                                        first argument,

                                        "node", contains the

                                    6.  -- Promise

                                        success data, which in

                                        this case is an opened

                                    7.  -- nodeDatabse
                                 8.  end);

promise:thenDo(successCallback,  Set continuation callback functions that
failureCallback)                 will be called when the Promise resolves
                                 to success or failure.

                                 Arguments:

                                           ● successCallback - A function
                                                that will be called if the
                                                Promise resolves to success.
                                                The first argument of the
                                                callback function will receive
                                                the associated success data

                                           ● failureCallback - A function
                                                that will be called if the
                                                Promise resolves to failure.
                                                The first argument of the
                                                callback function will receive
                                                the error message.

                                 Return:

                                           ● A new Promise object that
                                                will be resolved
                                                asynchronously with the
                                                execution of either the
                                                successCallback or
                                                failureCallback. This new
                                                promise can be used to chain
                                                promises handling.

                                 Remarks:

                                           ● This will monitor the Promise
                                                for both success and failure
                                                states at the same time

                                           ● If the Promise is already in a
                                                success state, the
                                                successCallback will be called
                                                as soon as possible.

                                           ● If the Promise is already in a
                                                failure state, the
                                                failureCallback will be called
                                                as soon as possible

                                           ● If the “successCallback” is
                                                called, “failureCallback” will
                                                never be called and vice versa.

                                 Example:

                                               1. local promise =

                                                       Firecast.asyncOpenUser
                                                       NDB("name");
                               2.

                               3. promise:thenDo(

                               4.   function(node)

                               5.             -- This

                                    function will be

                                    called when/if the

                               6.             -- Promise is

                                    resolved successfully.

                                    The first argument,

                               7.             -- "node",

                                    contains the Promise

                                    success data,

                               8.             -- which in

                                    this case is an opened

                                    nodeDatabase

                               9.   end,

                               10.

                               11.  function(errorMsg)

                               12.            -- This

                                    function will be

                                    called when/if the

                               13.            -- Promise is

                                    resolved to failure.

                                    The first argument,

                               14.            -- "errorMsg",

                                    contains the

                                    associated error

                                    message,

                               15.            -- which in

                                    this case is the

                                    message explaining why

                               16.            -- it was not

                                    possible to open the

                                    nodeDatabase

                               17.  end);

promise:thenFinally(callback)  Set a continuation callback function that
                               will be called when the Promise resolves,
                               whether to success or failure.

                               Arguments:

                                         ● callback - A function that will
                                              be called when the Promise
                                              resolves, regardless of the
                                              outcome. This function
                                              receives no parameters and
                                              will handle both success and
                                              failure cases.

                               Return:

                                         ● A new Promise object that
promise:thenResolve(promiseResoluti                 will be resolved
on)                                                 asynchronously with the
                                                    execution of the callback. This
                                                    new promise can be used to
                                                    chain promises handling.

                                     Remarks:

                                               ● Typically, this method is used
                                                    to establish a finalization
                                                    continuation that must be
                                                    executed regardless of the
                                                    promise outcome.

                                               ● This will monitor the Promise
                                                    for both success and failure
                                                    states at the same time

                                               ● If the Promise is already in a
                                                    success state, the callback will
                                                    be called as soon as possible.

                                               ● If the Promise is already in a
                                                    failure state, the callback will
                                                    be called as soon as possible

                                               ● The callback will be called
                                                    only once.

                                     Set a delegation that will resolve the
                                     provided PromiseResolution object with
                                     the same outcome (success or failure) as
                                     the original promise.

                                     Arguments:

                                               ● promiseResolution - a
                                                    PromiseResolution object
                                                    that will be resolved.

                                     Return:

                                               ● A new Promise object that
                                                    will be resolved
                                                    asynchronously along with
                                                    the delegation. This new
                                                    promise can be used to chain
                                                    promises handling.

                                     Remarks:

                                               ● If the promise is already
                                                    resolved, the
                                                    PromiseResolution will be
                                                    resolved as soon as possible.
promise:onError(failureCallback)  Set a continuation callback function that
                                  will be called when the Promise resolves
                                  to failure.

                                  Arguments:

                                           ● failureCallback - A function
                                                that will be called if the
                                                Promise resolves to failure.
                                                The first argument of the
                                                callback function will receive
                                                the error message.

                                  Return:

                                           ● A new Promise object that
                                                will be resolved
                                                asynchronously with the
                                                execution of failureCallback.
                                                This new promise can be used
                                                to chain promises handling.

                                  Remarks:

                                           ● If the Promise is already in a
                                                failure state, the
                                                failureCallback will be called
                                                as soon as possible

                                  Example:

                                            1. local promise =

                                                 Firecast.asyncOpenUser

                                                 NDB("name");

                                            2.

                                            3. promise:onError(

                                            4.   function(errorMsg)

                                            5.             -- This

                                                 function will be

                                                 called when/if the

                                            6.             -- Promise is

                                                 resolved to failure.

                                                 The first argument,

                                            7.             -- "errorMsg",

                                                 contains the

                                                 associated error

                                                 message,

                                            8.             -- which in

                                                 this case is the

                                                 message explaining why

                                            9.             -- it was not

                                                 possible to open the

                                                 nodeDatabase

                                            10.  end);
PromiseResolution object

  While a Promise object represents an asynchronous process that can be tracked by other parts of
  the code, a PromiseResolution object is responsible for providing a means to resolve its associated
  promise, either as a success or a failure.

Characteristics                              Descrição
Methods

   Método

promiseResolution:setSuccess([successData])  Resolves its associated promise as a
                                             success with the provided success
                                             data.

                                             Arguments:

                                                       ● (Optional) successData -
                                                            a Lua value that will be
                                                            associated as the
                                                            success data of the
                                                            promise.

                                             Return:

                                                       ● A boolean value; true
                                                            indicates successful
                                                            resolution of the
                                                            promise, while false
                                                            signifies that it was not
                                                            possible to resolve the
                                                            promise as a success.
                                                            This could occur if the
                                                            promise had already
                                                            been resolved to either
                                                            success or failure, and
                                                            its state cannot be
                                                            changed further.

                                             Remarks

                                                       ● If "successData" is a
                                                            Promise object, a
                                                            delegation will occur:
                                                            This promiseResolution
                                                            will monitor the
                                                            provided promise
                                                            object and whatever
                                                            resolution it has, be it
                                                            failure or success, this
                                                            promiseResolution will
promiseResolution:setFailure(errorMsg)                 also adopt.
promiseResolution:setUserAborted()
                                        Resolves its associated promise as a
                                        failure with the provided error
                                        message.

                                        Arguments:

                                                  ● errorMessage - a string
                                                       containing the reason
                                                       for the promise failure.

                                        Return:

                                                  ● A boolean value; true
                                                       indicates successful
                                                       resolution of the
                                                       promise, while false
                                                       signifies that it was not
                                                       possible to resolve the
                                                       promise as a failure
                                                       with the provided error
                                                       message. This could
                                                       occur if the promise had
                                                       already been resolved
                                                       to either success or
                                                       failure, and its state
                                                       cannot be changed
                                                       further.

                                        Resolves the associated promise as
                                        a failure because the user aborted
                                        the operation

                                        Arguments:

                                        None

                                        Return:

                                                  ● A boolean value; true
                                                       indicates successful
                                                       resolution of the
                                                       promise, while false
                                                       signifies that it was not
                                                       possible to resolve the
                                                       promise as a failure.
                                                       This could occur if the
                                                       promise had already
                                                       been resolved to either
                                                       success or failure, and
                                                       its state cannot be
                                                                                        changed further.

Remarks
            ● When a PromiseResolution object is garbage collected by Lua, and its associated
                 promise has not yet been resolved to either success or failure, the promise will be
                 automatically resolved to failure, signifying an abandoned promise.
```
