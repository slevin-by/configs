Config
	{
			font = "xft:Droid Sans Mono:size=9:bold:antialias=true"
		,	bgColor = "#000000",
		,	fgColor = "#ffffff",
		,	position =  Top --Static { xpos = 0, ypos = 0, width = 1920, height = 16 },
		,	lowerOnStart = True,
		,	commands =
				[
						Run Network "eth1" ["-L","0","-H","32","--normal","green","--high","red"] 10
					, 	Run Cpu ["-L","0","-H","50","--normal","green","--high","red"] 10
					, 	Run Memory ["-t","Mem: <usedratio>%"] 10
					, 	Run Date "%A | %Y-%m-%d %H:%M" "date" 10
					-- , 	Run Battery ["-L","15","-H","75","--high","green","--normal","yellow", "--low", "red"] 10
					,	Run Battery ["-t","Batt: <left>%","-L","15","-H","75","--high","green","--normal","yellow","--low","red"] 10
					, 	Run StdinReader
					--	Run Memory ["-t","<used>/<total>M (<cache>M)","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
					--,	Run Network "eth1"
					--		[
					--				"-t" ,"<dev> rx:<rx>, tx:<tx>"
					--			,	"-H" ,"200"
					--			,	"-L" ,"10"
					--			,	"-h" ,"#FFB6B0"
					--			,	"-l" ,"#CEFFAC"
					--			,	"-n" ,"#FFFFCC"
					--			, 	"-c" , " "
					--			, 	"-w" , "2"
					--			, 	"-S" , "True"
					--		] 10
					--,	Run Date "%Y.%m.%d %H:%M:%S" "date" 10
					--,	Run MultiCpu
					--		[
					--				"--template" , "<autototal>"
					--			, 	"--Low" , "50" -- units: %
					--			, 	"--High" , "85" -- units: %
					--			, 	"--low" , "gray"
					--			, 	"--normal" , "darkorange"
					--			, 	"--high" , "darkred"
					--			, 	"-c" , " "
					--			, 	"-w" , "3"
					--		] 10
					--,Run StdinReader
				],
		,		sepChar = "%",
		,		alignSep = "}{",
		,		template = "%StdinReader% }{ %battery% | %cpu% | %memory% | <fc=#FFFFCC>%date%</fc> "
	}