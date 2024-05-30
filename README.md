# ez2rename
A PowerShell script to rename your files with DOS-compatible (8.3) filenames.

The default behavior is to propose name changes with ~ followed by a number. It can handle large directories containing many files.

```
PS C:\Users\test\dosnametest2> C:\Users\test\Documents\dos-renamer.ps1

Original Name                                                        DOS Compatible Name
-------------                                                        -------------------      
New Text Document - Copy (10) - Copy - Copy - Copy - Copy - Copy.txt New Te~1.txt       
New Text Document - Copy (10) - Copy - Copy - Copy - Copy.txt        New Te~2.txt       
New Text Document - Copy (10) - Copy - Copy - Copy.txt               New Te~3.txt    
...
New Text Document - Copy - Copy.txt                                  New Te~997.txt     
New Text Document - Copy.txt                                         New Te~998.txt     
New Text Document.txt                                                New Te~999.txt     


Do you want to rename the files as proposed? (Y/N): y

PS C:\Users\test\dosnametest2> dir


    Directory: C:\Users\test\dosnametest2


Mode                 LastWriteTime         Length Name                                                                                                                   
----                 -------------         ------ ----                                                                                                                                                                                                                    
-a----         5/29/2024   7:34 PM              0 New Te~1.txt
...
-a----         5/29/2024   7:34 PM              0 New Te~999.txt
```

It also can take a switch `--hex` which will propose hexadecimal values and not use the ~ character:

```
PS C:\Users\test\dosnametest2> ..\Documents\dos-renamer.ps1 --hex

Original Name                                                        DOS Compatible Name
-------------                                                        -------------------
New Text Document - Copy (10) - Copy - Copy - Copy - Copy - Copy.txt New Te01.txt
New Text Document - Copy (10) - Copy - Copy - Copy - Copy.txt        New Te02.txt
New Text Document - Copy (10) - Copy - Copy - Copy.txt               New Te03.txt
...
New Text Document - Copy - Copy.txt                                  New T21E.txt
New Text Document - Copy.txt                                         New T21F.txt
New Text Document.txt                                                New T220.txt
```
