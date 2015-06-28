#SingleInstance,Force
json={"flan":{"consistency":"squishy"},"toast":{"consistency":"crunchy"}}
json:=json(json)
Transform(json) ;not necessary but it makes it easier to read
ToolTip,% json.xml
MsgBox,% json.SelectSingleNode("//*[@name='toast']/descendant::*/@value").text
return
GuiEscape:
ExitApp
return
json(json){
	temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath"),top:=temp.AppendChild(temp.CreateElement("json")),pos:=1,list:=[]
	while,RegExMatch(json,"OU)(\x22.*\x22|{|}|:|,|\[|\])",found,pos){
		if(type:=found.1="{"?"Object":found.1="["?"Array":""){
			new:=temp.CreateElement(type),top:=top.AppendChild(new)
			if(list[list.MaxIndex()]=":")
				top.SetAttribute("name",list[list.MaxIndex()-1])
		}
		if(found.1!="{"&&found.1!="}"&&found.1!="["&&found.1!="]"||found.1=","||found.1=":"||SubStr(json,pos,found.Pos(1)-pos)){
			if(list[list.MaxIndex()]=":")
				value:=SubStr(json,pos,found.Pos(1)-pos)?SubStr(json,pos,found.Pos(1)-pos):Trim(found.1,Chr(34)),new:=temp.CreateElement("value"),new:=top.AppendChild(new),new.SetAttribute("key",list[list.MaxIndex()-1]),new.SetAttribute("value",value)
		}
		if(found.1="}"||found.1="]")
			top:=top.ParentNode
		list.Insert(Trim(found.1,Chr(34)))
		pos:=found.Pos(1)+found.len(1)
	}
	return temp
}transform(xml){
	static
	if !IsObject(xsl){
		xsl:=ComObjCreate("MSXML2.DOMDocument")
		style=
			(
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
			<xsl:template match="@*|node()">
			<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:for-each select="@*">
			<xsl:text></xsl:text>		
			</xsl:for-each>
			</xsl:copy>
			</xsl:template>
			</xsl:stylesheet>
			)
		xsl.loadXML(style),style:=null
	}
	xml.transformNodeToObject(xsl,xml)
}