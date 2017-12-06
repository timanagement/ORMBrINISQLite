@echo off

del *.~*
del *.dcu
del descript.ion
del *.ddp
del *.map
del *.identcache 
del *.local
del *.drc
del *.stat

del /S /Q Win32\Release\*.exe
del /S /Q Win64\Release\*.exe
del /S /Q Win32\Release\*.dcu
del /S /Q Win64\Release\*.dcu
del /S /Q Win32\Release\*.map
del /S /Q Win64\Release\*.map
del /S /Q Win32\Release\*.drc
del /S /Q Win64\Release\*.drc
del /S /Q Win32\Release\*.bak
del /S /Q Win64\Release\*.bak
del /S /Q Win32\Release\*.rsm
del /S /Q Win64\Release\*.rsm

del /S /Q Win32\Debug\*.exe
del /S /Q Win64\Debug\*.exe
del /S /Q Win32\Debug\*.dcu
del /S /Q Win64\Debug\*.dcu
del /S /Q Win32\Debug\*.map
del /S /Q Win64\Debug\*.map
del /S /Q Win32\Debug\*.drc
del /S /Q Win64\Debug\*.drc
del /S /Q Win32\Debug\*.bak
del /S /Q Win64\Debug\*.bak
del /S /Q Win32\Debug\*.rsm
del /S /Q Win64\Debug\*.rsm

rd /S /Q __history
rd /S /Q __recovery