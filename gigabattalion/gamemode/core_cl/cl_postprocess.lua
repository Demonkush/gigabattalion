GIGABAT.PP = {}
GIGABAT.PP.MotionBlurEnabled = false
GIGABAT.PP.MotionBlur = {addalpha=0.4,drawalpha=0.8,delay=0.01}
function GIGABAT.Functions.StartMotionBlur()
	GIGABAT.PP.MotionBlurEnabled = true
end

function GIGABAT.Functions.StopMotionBlur()
	GIGABAT.PP.MotionBlurEnabled = false
end

function GIGABAT.Functions.ModifyMotionBlur(a,b,c)
	GIGABAT.PP.MotionBlur.addalpha	= a
	GIGABAT.PP.MotionBlur.drawalpha	= b
	GIGABAT.PP.MotionBlur.delay 	= c
end

function GIGABAT.Functions.PostProcess()
	if GIGABAT.PP.MotionBlurEnabled == true then
		DrawMotionBlur(GIGABAT.PP.MotionBlur.addalpha,GIGABAT.PP.MotionBlur.drawalpha,GIGABAT.PP.MotionBlur.delay)
	end
end
hook.Add("RenderScreenspaceEffects","GIGABATPP",GIGABAT.Functions.PostProcess)