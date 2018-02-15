# The Zen of OTP
## or How Elixir Guides You to the Answer

This piece traces the development of a toy application. The branch order to follow is:

1. `master`
2. `registry`
3. `fault-tolerant`
4. `kill-children` (probably should have more thoughtfully named this branch)
5. `one-last-thing`

Much has been written about OTP. Maybe too much. One of the challenging aspects of Elixir arises from the fact that it's built atop another language that's had decades to mature. That language, Erlang, has had so much time to mature, in fact, that the OTP framework has managed to shape its core philosophy and, by extension, that of Elixir's. The community loves to talk about Elixir's fault tolerance and green Erlang VM processes, but the truth--it seems to me anyway--is these don't come for free per se and there's a dearth of examples demonstrating these concepts.

In most languages, spinning up a new process is one of those things they say you should only do under the most dire of circumstances.

## From First Principles

I was compelled to write this series after a colleague asked for some guidance regarding Elixir and OTP while writing a CSRF token application. This series will create a simplified version of that application. If you're following along, let's begin by creating a new, supervised Elixir project by running `mix new hang_ten --sup`. The `--sup` flag tells Mix that this is a supervised project and will scaffold the appropriate files on our behalf.

Before we continue, let's talk about the functionality of this application. It should accept a user's login along with a token and perform some validation of that user and token. Now, the naive implementation might be to hold all of the application's state in a single data structure, but remember that Elixir _really_ wants you to leverage the Erlang VM. So, rather than doing things the Node.js or Python way, let's think about how we can model the state with processes.

Rather than burdening ourselves with unnecessary complexity from the outset, the objective of this section will be to create a basic supervision tree where workers are GenServer's whose state is simply a login.

### `application.ex`

Line 19 of Mix.exs lists the application's entry point: it will invoke the `start` function in the HangTen.Application module, so let's begin there. If we navigate to that module, we'll see that it's singly function doesn't do much other than start an Elixir Supervisor. This supervisor, found in supervisor.ex, is the application's top-level supervisor. If it shuts down, HangTen shuts down. 

### `supervisor.ex`

One of the interesting features of this module is that it leverages the new (at the time of writing) DynamicSupervisor process. While supervisors were largely created to spawn a fixed number of children, the DynamicSupervisor was recently added to address the case where the number of children is not known before runtime or will fluctuate with time. Because users will create their tokens at runtime, and we don't know how many user tokens will exist at any point in time, DynamicSupervisor seems like a good fit. We'll also init the DynamicSupervisor with the :one_for_one strategy because we don't want the destruction of one child process to affect other child processes. Lastly, we define a function called `start_child` to describe how supervised, child processes are created. In this case, it will initialize a GenServer with the user's login.

### `server.ex`

This module represents just about the simplest GenServer one could create. It exposes the `start_link` functionality and contains the `init` callback; neither of which are sophisticated. The server exposes one `handle_cast` callback where it matches the `:boom` atom. All callback does is kills the GenServer process for purposes of tinkering. Lastly, there's the super-important-but-surpisingly-rarely-used `terminate` callback. This callback is always* called before the GenServer exits and will actually be the key to our fault tolerance later on. Right now it simply logs the server's state and reason for exiting.

### Let's Play

If we start the application with `iex -S mix` and open the observer with `:observer.start`, we should see the process tree under the application's tab. Your process tree should look something liked this:

# TODO: PUT PIC HERE

If you add a user by typing `HangTen.new "somename"`, you should see the newly created process added to the supervision tree:

# TODO: PUT PIC HERE

We can add as many processes as we want by continuing to call `HangTen.new "someothername"` and watch as our process tree grows:

# TODO: PUT PIC HERE

Now, we'll test the fault tolerance of our newly created processes by trying to kill them. With the observer still running, let's create and kill a new process by running the following commands:

```elixir
iex(3)> {:ok, eric_pid} = HangTen.new "erchurchill"
{:ok, #PID<0.123.0>}
iex(4)> HangTen.boom! eric_pid
** (exit) exited in: GenServer.call(#PID<0.123.0>, :boom, 5000) 
```

The `** (exit) exited...` line tells us that we definitely killed the "erchurchill" process. However, if we look at our supervision tree all the child processes appear to be accounted for. In fact, if we inspect our newly created process's state with the observer, we see that our state has been preserved!

# TODO: PUT PIC HERE

It's pretty amazing how much can be expressed with so little. Indeed this will be a theme as we start to build out this application.

There are, however, problems with our current implementation. Can you spot them? This version of the application uses Process Identifiers to reference child processes, which aren't very expressive, increase the cognitive overhead of the code, and aren't serializable. Furthermore, we've only managed to preserve the GenServer's initial state. If the server's state had been mutated, that mutation would be lost. Worst yet, if the process dies what of our reference to that process? We were able to locate the process using the observer tool, but how do we recover that PID within our programs? 

I feel like this is the point where almost all of the tutorials and articles out there stop short, but follow along as we learn how to surmount these problems and understand what people mean when they talk about OTP.
