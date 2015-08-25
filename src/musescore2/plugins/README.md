# Musescore 2 QML Plugin Tin Whistle Notation

The plugin code can be found in _tinwhistle.qml_

__Tin Whistle Notation__ implements a Musescore 2 QML (Qt Meta Language or
Qt Modeling Language) plugin. Objective of the plugin is to ease creation
of Tin Whistle Fingering Annotations in music scores.

The Fingering dictionary mapping used inside the plugin matches the notes pitch onto
characters in a font position as in __TinWhistleFingering font__.

The __TinWhistleFingering font__ is licensed under a
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License,
http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US
and is available on
https://github.com/OMerkel/tin_whistle/tree/master/res/font 

There are properties hardcoded in the plugin.

Property __fingering__ is a dictionary mapping from notes pitch
onto character in a font to select for the staff text style.
The notes pitch values are correct for unmodified Treble clef
only with notes pitches as given.

Property __offsetystafftext__ represents a hardcoded value describing the
vertical offset of staff text that will hold the annotation.
With lyrics of no or one line a value of 10 is appropriate.

Mind to switch staff text to use the __TinWhistleFingering__ font.
One possible way to establish this in Musescore 2 is as follows:

* Goto menu _Style_,
* select entry _Text..._,
* select _Staff_,
* choose _Text Font_ as __Tin Whistle Fingering__ (font to be installed first),
* use _Size_ of e.g. _40_,
* then select _Apply_ / _OK_

# Legal

Logos and trademarks belong to their respective owners.

Copyright (c) 2015 Oliver Merkel

See LICENSE files plus license information included in file meta data if available being part of the repository on exact legal information.
