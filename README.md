# AmigaApolloAssembler
Using the Amiga Apollo V4SA to create a shell and then games and tools.

## Development
Development is currently done on the Amiga Apollo unit, using ASMPro v1.21b.

For stability I am using AmigaOS 3.2.2.1 as this behaves with ASMPro running in RTG mode (1024x768 8bit). As with most older platforms there are drawbacks, the main one being debugging assumes one file, multiple source files mean it does not source track into these files, there is only one line of disassembler available. 

However, it's wonderful being able to development using the platform I started to develop on in the mid 80s.

## Notes on ASMPro v1.21b
Firstly I got the source from Aminet and built that using ASMone.

Each file current dumps the preferences for that file, in the first line of the source and this is hidden within the editor. 

The main first visible line is the markers for the custom tabs, this is generally copied to new files alone with the header. Example below shows the layout of the custom tabs line. Note the capital ```T``` marks a tab stop.
``` asm
;---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T---T
```

### Todo

I have only just started this, I will add clang-format, that I will run over the files before checking into  the ```develop``` branch.

I will try and get doxygen included for documentation. 






