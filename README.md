# HubbleBubble — RedBubble Developer Test

This is [Dave Sag](http://cv.davesag.com)'s implementation of the [RedBubble](http://www.redbubble.com/people/davesag)'s developer test.

*If you have been asked to do this test I urge you to not to copy my, or anyone else's, work.*

## Declaration

I solemnly declare that I did not copy this code from anyone else, and that it's all my own original  work.

## Approach

I selected `Ruby version 2.2.0` as the language to write this in, which is fair given I am pitching for a `Ruby` focused job.

I started by converting the requirements into a simple suite of `rspec` tests set to `skip` just to get down everything I figured I'd need. I then enhanced the tests with some `unhappy-path` tests as well.  Then I implemented the main app functions, the `reader`, `writer`, and `presenter` in that order; turning the tests from `skipping`, to `pending`, to `passing`.

The brief is silent on how to deal with erroneous input, such as missing camera makes and models. I chose to simply refer to these as 'Unknown'.

Once the tests were all working for the core functions, and the design had been DRYed up a bit, I polished the output slightly and updated this `Readme`.

I selected the following `Gems` to assist me.

* [`nokogiri`](http://www.nokogiri.org) as an XML parser because it's the best,
* [`slim`](http://slim-lang.com) as a page renderer as it's simple, fast, and easy to work with
* [`sass`](http://www.nokogiri.org) to dry up the inline css<sup>*</sup>, and
* [`cobravsmongoose`](https://rubygems.org/gems/cobravsmongoose) to convert XML to a ruby `Hash` as it supports `attribute` parsing.

<sup>*</sup> The brief expects the output to conform to a specific `output-template` and I have stuck to this, but I chose to arrange the navigation and thumbnails horizontally instead of just as a list as it looks much nicer. I also added a very minimal amount of styling to the Nav Item's hover states. If that's unacceptable then it's a trivial change to the inline SCSS in `views/page.slim` to revert this.

## Design

There are four classes, contained within an overarching `HubbleBubble` module.

1. `App` — The command line app that accepts a path to an xml file and an output folder as params. It ensures the supplied files exist and substitutes defaults if no params are provided.
2. `WorksReader` — Reads the supplied XML file and converts it into an array of Hashes containing the parsed `work` data.
3. `WorksPresenter` — Manages the rendering of the output and contains various convenience and helper methods to support that process.
4. `WorksWriter` — Writes the rendered information out to the output folder.

## Setup

There are a few dependencies so first run

```sh
bundle install
```

### If you are having trouble installing `nokogiri`

`Nokogiri` is used to parse the XML file.  It's awesome but can be troublesome to install.  See [this documentation](http://www.nokogiri.org/tutorials/installing_nokogiri.html) for details.

## To run

```sh
ruby hubble_bubble.rb
```

It will load the `works.xml` file from within the `brief/` folder and render output into an `output/` folder.
If you wish you can specify your own `input file` and `output folder` as follows:

```sh
ruby hubble_bubble.rb my_input.xml put_it_here/
```

## To test

Simply run

```sh
rspec
```

There are 22 tests giving an over 80% code coverage of the project. The code that's not covered by tests is extremely simple.

## License

Even though you are not meant to copy this if doing a test; I'm not at all precious about it, and hey, it's not my test, just my stab at it.

The MIT License (MIT)

Copyright (c) 2015 Dave Sag

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

The files in the `brief` folder were supplied by [RedBubble](http://www.redbubble.com/people/davesag) and so naturally the copyright of those remains with RedBubble. They are included here under "fair use" provisions of [section 40 of the Australian Copyright Act 1968](http://www.austlii.edu.au/au/legis/cth/consol_act/ca1968133/s40.html).

