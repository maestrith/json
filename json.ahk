#SingleInstance,Force
;your json
json=
;/your json
tick:=A_TickCount,object:=json(json),tick:=A_TickCount-tick
Loop,2
	object.Transform()
clipboard:=text:=json "`n`n`n" Object[] "`n`nCompiled in " tick "ms"
;m(object.ssn("//Object[@name='tree']/descendant::value[@key='sha']/@value").text)
Gui,Add,Edit,w1200 h800,%text%
Gui,Show
return
json(json){
	temp:=new xml("temp"),top:=temp.ssn("//*")
	pos:=1,list:=[]
	while,RegExMatch(json,"OU)({|}|\x22.*\x22|:|,|\[|\])",found,pos){
		if(type:=found.1="{"?"Object":found.1="["?"Array":""){
			top:=temp.under(top,type)
			if(list[list.MaxIndex()]=":")
				top.SetAttribute("name",list[list.MaxIndex()-1])
		}
		if(found.1~="({|}|,|\[|\])"=0||found.1~=":"||SubStr(json,pos,found.Pos(1)-pos)){
			if(list[list.MaxIndex()]=":"){
				value:=SubStr(json,pos,found.Pos(1)-pos)?SubStr(json,pos,found.Pos(1)-pos):Trim(found.1,Chr(34))
				temp.under(top,"value",{key:list[list.MaxIndex()-1],value:value})
			}
		}
		if(found.1="}"||found.1="]")
			top:=top.ParentNode
		list.Insert(Trim(found.1,Chr(34)))
		pos:=found.Pos(1)+found.len(1)
	}
	return temp
}
t(x*){
	for a,b in x
		list.=b "`n"
	Tooltip,% list
}
m(x*){
	for a,b in x
		list.=b "`n"
	MsgBox,,AHK Studio,% list
}
GuiEscape:
ExitApp
return
#Include xml.ahk