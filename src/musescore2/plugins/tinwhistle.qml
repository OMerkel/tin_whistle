/**
 * @file tinwhistle.qml
 * @author Oliver Merkel <Merkel(dot)Oliver(at)web(dot)de
 * @date 2015, August 18th
 *
 * @section LICENSE
 *
 * Copyright (c) 2015, Oliver Merkel <Merkel(dot)Oliver(at)web(dot)de
 * All rights reserved.
 *
 * The Musescore 2 QML Plugin Tin Whistle Notation is released under the MIT license.
 *
 * @section DESCRIPTION
 *
 * @brief Musescore 2 QML Plugin Tin Whistle Notation
 *
 * Tin Whistle Notation implements a Musescore 2 QML (Qt Meta Language or
 * Qt Modeling Language) plugin. Objective of the plugin is to ease creation
 * of Tin Whistle Fingering Annotations in music scores.
 * 
 * The Fingering dictionary mapping used below matches the notes pitch onto
 * characters in a font position as in TinWhistleFingering font.
 *
 * The TinWhistleFingering font is licensed under a
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License,
 * http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US
 * and is available on
 * https://github.com/OMerkel/tin_whistle/tree/master/res/font 
 * 
 */

import QtQuick 2.0
import MuseScore 1.0

MuseScore {
  version:  "1.0"
  description: "Tin Whistle plugin supports creation of fingering chart diagrams depending on pitch"
  menuPath: "Plugins.Tin Whistle Notation"

  /**
   * Fingering is a dictionary mapping from notes pitch
   * onto character in a font to select for the
   * staff text style.
   *
   * Notes pitch values are correct for unmodified
   * Treble clef only with notes pitches as given.
   */
  property variant fingering : { 62: "d", 64: "e", 66: "l",
    67: "g", 69: "a", 71: "b", 72: "C", 73: "I", 74: "D",
    76: "E", 78: "L", 79: "G", 81: "A", 83: "B", }

  /**
   * offsetystafftext represents a hardcoded value describing the
   * vertical offset of staff text that will hold the annotation.
   *
   * With lyrics of no or one line a value of 10 is appropriate.
   * 
   * Mind to switch staff text to use the TinWhistleFingering font.
   * This can be established in Musescore 2 as follows:
   * Goto menu Style, select entry Text..., select Staff,
   * choose Text Font as Tin Whistle Fingering (font to be
   * installed first), use Size of e.g. 40, then select Apply / OK
   */
  property variant offsetystafftext : 10
  
  function createTinWhistleFingering(note) {

    console.log("Pitch - " + note.pitch);

    return fingering[note.pitch];
  }

  function applyOntoNotes(func) {
    var cursor = curScore.newCursor();
    cursor.staff = 0;
    cursor.rewind(1);
    var fullScore = !cursor.segment;
    var startStaff = fullScore ? 0 : cursor.staffIdx;
    var endTick;
    if (!fullScore) {
      cursor.rewind(2);
      endTick = 0 == cursor.tick ? curScore.lastSegment.tick + 1 : cursor.tick;
    }
    var endStaff = fullScore ? curScore.nstaves - 1 : cursor.staffIdx;

    console.log(startStaff + " - " + endStaff + " - " + endTick);

    for (var staff = startStaff; staff <= endStaff; staff++) {
      cursor.rewind(1);
      cursor.voice = 0;
      cursor.staffIdx = staff;
      if (fullScore)
        cursor.rewind(0);
      while (cursor.segment && (fullScore || cursor.tick < endTick)) {
        if (cursor.element && cursor.element.type == Element.CHORD) {
          var graceChords = cursor.element.graceNotes;
          for (var i = 0; i < graceChords.length; i++) {
            var notes = graceChords[i].notes;
            for (var j = 0; j < notes.length; j++) {
              var note = notes[j];
              var text = func(note);
              if (typeof text === 'undefined') {
                console.log("Undefined mapping for pitch " + note.pitch );
              } else {
                var element = newElement(Element.STAFF_TEXT);
                element.text = text;
                // element.defaultFont = font;
                element.pos.y = offsetystafftext;
                cursor.add(element);
              }
            }
          }
          var notes = cursor.element.notes;
          for (var i = 0; i < notes.length; i++) {
            var note = notes[i];
            var text = func(note);
            if (typeof text === 'undefined') {
              console.log("Undefined mapping for pitch " + note.pitch );
            } else {
              var element = newElement(Element.STAFF_TEXT);
              element.text = text;
              // element.defaultFont = font;
              element.pos.y = offsetystafftext;
              cursor.add(element);
            }
          }
        }
        cursor.next();
      }
    }
  }

  onRun: {
    console.log("Hello Tin Whistler!");
    if (typeof curScore !== 'undefined')
      applyOntoNotes(createTinWhistleFingering);
    Qt.quit();
  }
}
