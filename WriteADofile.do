*Making your dofile write a dofile based on information in a excel sheet or txt file
 clear
 
 cd "..."
 import excel "ExampleExcelDoFilebase.xlsx", sheet("Sheet1") firstrow allstring
 tempname fh
file open `fh' using "Dofile.do", write replace
file write 	`fh' "*Title" _newline "clear" _newline 

/*Example uses an Excel sheet with a variable on Code including a theoretical list of disease codes these could be e.g. ICD10 codes or SNOMED codes and Disease group column including the name of the disease group these codes belong to. There is several codes defining any group pf diseases.


The below code writes a dofile that will have each disease generated = Disease1 Disease2...=0
And replace code including each Code e.g. replace Disease1=1 if Code=="xxxx"
Note that all written text that will ned up in the do-file has quotation marks. Where the result is put in the text is in brackets e.g. (Code[`line']). Any single quotes in the quotations will result in the local/foreach to be used in the text. Where you want double quotations in the do-file use `"""' inbetween, where you want single quotations e.g. to reference a local a you must use "`"`"a"'"'" - in both cases it works best to split these from the rest of the text to avoid mistakes. To seperate text by tab use _newline , by a blank use _skip() or if right next to it only a blank . 
*/

encode DiseaseGroup, generate(Group) 
sort Group
quietly: tab Group
local R=r(r)
display `R'
local start=1
forval n=1/`R'{
quietly: tab Code if Group==`n'
local end=`start'+r(r)-1
file write `fh' "gen Disease`n'=0" _newline
	local naming: label Group `n'
file write `fh' "label var Disease`n' `naming'"  _newline
forval line=`start'/`end'{
file write `fh' "		replace Disease`n'=1 if Code==" `"""' (Code[`line']) `"""' _newline 
}
local start=`end'+1
}



/*# THE RESULT OF THE ABOVE CODE IS THE FOLLOWING:

			*Title
			clear
			gen Disease1=0
			label var Disease1 TestDisease1
						   replace Disease1=1 if Code=="10000001"
						   replace Disease1=1 if Code=="10000002"
						   replace Disease1=1 if Code=="10000003"
						   replace Disease1=1 if Code=="10000004"
			gen Disease2=0
			label var Disease2 TestDisease2
						   replace Disease2=1 if Code=="10000005"
						   replace Disease2=1 if Code=="10000006"
						   replace Disease2=1 if Code=="10000007"
						   replace Disease2=1 if Code=="10000008"
						   replace Disease2=1 if Code=="10000009"
			gen Disease3=0
			label var Disease3 TestDisease3
						   replace Disease3=1 if Code=="10000010"
						   replace Disease3=1 if Code=="10000011"
						   replace Disease3=1 if Code=="10000012"
			gen Disease4=0
			label var Disease4 TestDisease4
						   replace Disease4=1 if Code=="10000013"
*/
