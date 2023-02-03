
--能在屏幕中出现的漂浮文字
hGlobal.UI.Initscreenfloatnumber = function()
	
	hGlobal.event:listen("localEvent_FloatNumber","showfrm",function(text,x,y,font,size,lifetime)
		hUI.floatNumber:new({
			x = x or hVar.SCREEN.w/2+64,
			y = y or hVar.SCREEN.h/2+64,
			lifetime = lifetime or 1500,
			moveY = 64,
		}):addtext(tostring(text),font or hVar.FONTC,size or 48,"MC",0,0):runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1),CCFadeOut:create(0.5)))
	end)
end