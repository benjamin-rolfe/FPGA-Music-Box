# FPGA Music Box in VHDL

This project is a simple **FPGA music box** written in **VHDL**. It plays a melody through a buzzer by turning musical notes into clock divider values. The included song is **Für Elise**.

The project is designed for an FPGA board with:

- a system clock input
- a reset button
- a buzzer or speaker output pin

Instead of storing raw frequencies manually in the main circuit, the project defines musical notes such as `C4`, `E5`, and `REST`, then uses a finite state machine to step through a song one note at a time.

---

## What This Project Does

This project creates a small digital music player on an FPGA.

In plain English:

1. The FPGA receives a fast clock signal.
2. The code slows that clock down to make musical tones.
3. A song is stored as a list of notes.
4. The circuit moves through the notes one by one.
5. Each note is sent to the buzzer output.
6. The buzzer plays the melody.

---

## Main Features

- Plays music through a buzzer or speaker output
- Uses readable musical note names like `C4`, `D5`, `A4`, and `REST`
- Includes a pre-written version of **Für Elise**
- Supports notes from octave 2 through octave 6
- Uses a finite state machine to move through the song
- Includes reset support using a button input
- Allows songs to be written as simple note lists
- Separates reusable music definitions into a VHDL package

---

## Project Files

The project is made of four VHDL files.

| File | Purpose |
|---|---|
| `music_types_pkg.vhd` | Defines the musical notes, clock divider values, and built-in songs |
| `clock_divide.vhd` | Slows down the FPGA clock to create note frequencies |
| `music_box_fsm.vhd` | Controls the song playback using a finite state machine |
| `main.vhd` | Top-level file that connects the clock, reset button, song, and buzzer |

If your downloaded files have long random names, rename them to the names above before adding them to your FPGA project.

---

## How the Code Works

### 1. `music_types_pkg.vhd`

This file defines the custom music system used by the rest of the project.

It contains:

- `pitch_t`: a custom type that lists every supported note
- divider constants such as `DIV_C4`, `DIV_A5`, and `DIV_REST`
- `song_t`: a custom array type used to store songs
- built-in songs, including `my_fur_elise`

Example song format:

```vhdl
constant REST_SONG: song_t := (REST, REST, REST, REST);
```

Each item in the list is one note. This makes songs easier to read and edit.

---

### 2. `clock_divide.vhd`

This file creates a clock divider.

An FPGA clock is usually too fast to directly drive a buzzer at musical frequencies. The clock divider counts clock cycles and toggles an output when the count reaches a chosen value.

For example:

- a larger divider value creates a lower note
- a smaller divider value creates a higher note
- `DIV_REST` turns the output off for a rest

This module is used twice:

1. once to control the speed of the song
2. once to generate the actual buzzer tone

---

### 3. `music_box_fsm.vhd`

This is the main playback controller.

It uses a finite state machine, or FSM, to step through the song.

Each state represents one note in the song.

For each note, the FSM:

1. looks at the current note
2. chooses the correct divider value
3. sends that divider value to the tone generator
4. waits for the tempo clock to tick
5. moves to the next note

When the song reaches the end, the current version stops on the last note.

This line controls that behavior:

```vhdl
next_state <= song'right;
```

To make the song loop instead, change it to:

```vhdl
next_state <= song'left;
```

---

### 4. `main.vhd`

This is the top-level design file.

It connects the outside FPGA pins to the music box.

Inputs:

- `clk`: the FPGA clock
- `key4_l`: an active-low reset button

Output:

- `buzzer`: the signal connected to the buzzer or speaker

The current song is selected here:

```vhdl
music_box: entity work.music_box_fsm
    port map (
        clk    => clk,
        song   => my_fur_elise,
        reset  => key4,
        buzzer => buzzer
    );
```

To play a different song, replace `my_fur_elise` with another song constant from `music_types_pkg.vhd`.

---

## Requirements

To use this project, you need:

- an FPGA development board
- FPGA software such as Intel Quartus Prime, AMD/Xilinx Vivado, or another VHDL-compatible tool
- a buzzer or small speaker connected to an FPGA output pin
- basic pin assignments for your board

This is not a Windows, macOS, or Linux application. It must be compiled using FPGA design software.

---

## How to Run the Project

These steps are written for a beginner using Intel Quartus Prime, but the same general idea applies to other FPGA tools.

### Step 1: Download the Code

Download or clone this repository:

```bash
git clone https://github.com/fentadryl/FPGA-Music-Box.git
```

Then open the project folder.

---

### Step 2: Create a New FPGA Project

Open your FPGA software and create a new project.

For Quartus Prime:

1. Open Quartus Prime.
2. Select **File > New Project Wizard**.
3. Choose a project folder.
4. Name the project something like `fpga_music_box`.
5. Select your FPGA board or chip model.

---

### Step 3: Add the VHDL Files

Add the VHDL files to the project in this order:

1. `music_types_pkg.vhd`
2. `clock_divide.vhd`
3. `music_box_fsm.vhd`
4. `main.vhd`

The order matters because some files depend on others.

---

### Step 4: Set the Top-Level Entity

Set `main` as the top-level entity.

In Quartus, this is usually done by right-clicking `main.vhd` and selecting:

```text
Set as Top-Level Entity
```

---

### Step 5: Assign FPGA Pins

You must connect the VHDL ports to real pins on your FPGA board.

The top-level ports are:

| Port | Direction | Description |
|---|---|---|
| `clk` | Input | FPGA clock signal |
| `key4_l` | Input | Reset button, active low |
| `buzzer` | Output | Buzzer or speaker signal |

Use your board manual to find the correct pin names.

Example assignments might look like this, but they will depend on your board:

| Signal | Example Hardware |
|---|---|
| `clk` | 50 MHz onboard clock |
| `key4_l` | Push button |
| `buzzer` | GPIO pin connected to buzzer |

Do not copy pin numbers from another board unless you know they match your hardware.

---

### Step 6: Compile the Project

Compile or synthesize the project in your FPGA tool.

In Quartus:

```text
Processing > Start Compilation
```

If the project compiles successfully, the software will generate a programming file for your FPGA.

---

### Step 7: Program the FPGA

Connect your FPGA board by USB and program it using your FPGA software.

In Quartus:

1. Open **Tools > Programmer**.
2. Select your hardware programmer.
3. Add the generated `.sof` file.
4. Click **Start**.

Once programmed, the buzzer should play the song.

---

## How to Change the Song

Songs are stored in `music_types_pkg.vhd`.

A song is just a list of notes:

```vhdl
constant my_song : song_t := (
    C4, D4, E4, F4, G4, REST, G4, F4, E4, D4, C4
);
```

Then, in `main.vhd`, change the song being passed into the music box:

```vhdl
song => my_song
```

Supported notes include:

- `REST`
- `C2` through `B2`
- `C3` through `B3`
- `C4` through `B4`
- `C5` through `B5`
- `C6` through `B6`

Sharp notes use `S` in the name.

Examples:

| Musical Note | VHDL Name |
|---|---|
| C sharp 4 | `CS4` |
| D sharp 5 | `DS5` |
| F sharp 3 | `FS3` |
| A sharp 4 | `AS4` |

---

## How to Change the Tempo

The tempo is controlled in `music_box_fsm.vhd`:

```vhdl
signal tempo: integer := 3_500_500;
```

To make the song faster, lower the number.

To make the song slower, raise the number.

Example:

```vhdl
signal tempo: integer := 2_000_000; -- faster
```

```vhdl
signal tempo: integer := 5_000_000; -- slower
```

---

## Important Notes

The divider values in `music_types_pkg.vhd` are written for a 50 MHz FPGA clock.

If your board uses a different clock speed, the notes may sound too high, too low, or incorrect. To fix that, the divider values must be recalculated for your board clock.

The current song uses equal-length notes. In other words, every note lasts the same amount of time. This keeps the design simple but does not perfectly reproduce real sheet music timing.

---

## Troubleshooting

### I do not hear sound

Check that:

- the buzzer is connected to the correct FPGA pin
- the `buzzer` output is assigned to the correct pin
- the board is programmed successfully
- the reset button is not being held down
- the buzzer works with your board voltage

### The notes sound wrong

The divider values are probably not matched to your FPGA clock.

This project assumes a 50 MHz clock.

### The project does not compile

Make sure the files are added in this order:

1. `music_types_pkg.vhd`
2. `clock_divide.vhd`
3. `music_box_fsm.vhd`
4. `main.vhd`

Also make sure `main` is set as the top-level entity.

### The song only plays once

That is the current behavior.

To make it loop, edit `music_box_fsm.vhd` and change:

```vhdl
next_state <= song'right;
```

To:

```vhdl
next_state <= song'left;
```

---

## Possible Future Improvements

- Add multiple selectable songs
- Add switches to choose the song
- Add note lengths for quarter notes, half notes, and whole notes
- Add a pause/play button
- Add a tempo control input
- Add LED indicators for the current note
- Add support for more octaves
- Add a simulation testbench

---

## Summary

This project demonstrates how an FPGA can be used to generate music using digital logic. It combines a clock divider, a custom music note package, and a finite state machine to play a recognizable melody through a buzzer.

The code is organized so that songs can be written as readable note lists instead of raw frequency numbers, making the project easier to understand, modify, and expand.
