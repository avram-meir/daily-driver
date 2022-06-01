# daily-driver

A template driver script to update and maintain a daily archive of files 

## About

This README serves two purposes: to describe the template daily-driver script and how to use it, and to serve as a sample README for your own projects that you start using daily-driver as a template.

### Built With

* [Bash](https://www.gnu.org/software/bash/)
* Add other software you use in your project

## Getting Started

### Environment

This application is designed to run in the [bash shell](https://www.gnu.org/software/bash/). The bash shell is available on Linux and MacOS systems, on [Windows systems via Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install), and on ChromeOS via the [Crostini (Debian Linux based) container](https://support.google.com/chromebook/answer/9145439?hl=en).

### Prerequisites

The daily-driver application relies on other software that needs to be installed on your system.

#### Install git

See [Git - Installing git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for more information about installing git on your system.

### Installation

1. Clone the repo:
```
     git clone git@github.com:avram-meir/daily-driver.git
```
2. Do any other stuff that you need to do to get this installed.

## Usage

This is the meat and bones of the README. Add stuff here on how to set up and run the application and how to make it do useful and productive things.

### How to run

#### Driver script

The entire functionality of daily-driver is governed by a bash script: `daily-driver.sh`. This script can be run on [cron](https://man7.org/linux/man-pages/man5/crontab.5.html) to update your favorite date-based archives with new data, while taking steps to ensure the archives are as complete as possible.

**Usage:** `./daily-driver.sh [options]`

**Options:**

<table>
  <tr><th>Option&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th><th>Description</th></tr>
     <tr><td><code>-b &lt;string&gt;</code></td><td>Pass a valid <a href="https://man7.org/linux/man-pages/man1/date.1.html">GNU date</a> delta (e.g., '-30 days' or '10 days ago') and the script will scan the archive described by the configuration file provided through the -c option for missing files for that many days before the earliest date supplied through the -d option. If no -c option is supplied, the script will [do what you set it up to do] for each of those days. If no -d option is supplied, the date delta will apply to today's date (e.g., ./daily-driver.sh -b '-30 days' will [do what you set it up to do] for the 30 days leading up to today's date and today as well).</td></tr>
     <tr><td><code>-c &lt;filename&gt;</code></td><td>Pass a configuration file that lists all of the expected files in the archive. When updating for a date, the script will check for the existence of these files. If they do not exist, then the script will [do what you set it up to do]. If they do exist, the script will do nothing and move to the next date in the list. See below for the required format of the configuration file.</td></tr>
     <tr><td><code>-d &lt;date&gt;</code><br>&nbsp;&nbsp;&nbsp;&nbsp;or<br><code>-d &lt;date1 date2&gt;</code></td><td>Pass a date to update, or a start date and stop date to update for a range of days. The dates should be provided in a format understood by GNU date's --date option.</td></tr>
     <tr><td><code>-h</code></td><td>Print a usage statement and exit.</td></tr>
     <tr><td><code>-l &lt;filename&gt;</code></td><td>Pass a file containing a list of dates to update. Any dates where [what you set it up to do] fails will be written back to this file, while dates that have a successful run (or already have existing files in the archive defined by the -c option) will be removed from this file. This is a good way to keep track of gaps in your archives.</td></tr>
</table>

## Roadmap

See the [open issues](../../issues) for a list of proposed features and reported problems.

## Contributing

Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. [Open a Pull Request](../../pulls)

## Contact

Adam Allgood
