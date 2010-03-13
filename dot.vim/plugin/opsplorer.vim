" opsplorer - treeview file explorer for vim
"
" Author:  Patrick Schiel
" Date:    2009/03/18
" Email:   p.schiel@gmail.com
" Version: 1.2
"
" see :help opsplorer.txt for detailed description

" setup command {{{
command! -nargs=* -complete=dir Opsplore call Opsplore(<f-args>)
noremap <silent> <F10> :call ToggleShowOpsplorer()<CR>
" }}}

" InitOptions() - init script options{{{
function! InitOptions()
	let s:single_click_to_edit=0
	let s:file_match_pattern=''
	let s:show_hidden_files=0
	let s:split_vertical=1
	let s:split_width=24
	let s:split_minwidth=1
	let s:use_colors=1
	let s:close_explorer_after_open=0
endfunction
" }}}
" InitMappings() - init keyboard and mouse mappings{{{
function! InitMappings()
	noremap <silent> <buffer> <LeftRelease> :call OnClick()<CR>
	noremap <silent> <buffer> <2-LeftMouse> :call OnDoubleClick(-1)<CR>
	noremap <silent> <buffer> <Space> :call OnDoubleClick(1)<CR>
	noremap <silent> <buffer> <CR> :call OnDoubleClick(0)<CR>
	noremap <silent> <buffer> <Down> :call GotoNextEntry()<CR>
	noremap <silent> <buffer> <Up> :call GotoPrevEntry()<CR>
	noremap <silent> <buffer> <S-Down> :call GotoNextNode()<CR>
	noremap <silent> <buffer> <S-Up> :call GotoPrevNode()<CR>
	noremap <silent> <buffer> <BS> :call BuildParentTree()<CR>
	noremap <silent> <buffer> q :call CloseOpsplorer()<CR>
	noremap <silent> <buffer> n :call InsertFilename()<CR>
	noremap <silent> <buffer> p :call InsertFileContent()<CR>
	noremap <silent> <buffer> s :call FileSee()<CR>
	noremap <silent> <buffer> N :call FileRename()<CR>
	noremap <silent> <buffer> D :call FileDelete()<CR>
	noremap <silent> <buffer> C :call FileCopy()<CR>
	noremap <silent> <buffer> O :call FileMove()<CR>
	noremap <silent> <buffer> H :call ToggleShowHidden()<CR>
	noremap <silent> <buffer> M :call SetMatchPattern()<CR>
	noremap <ESC>[5~ 10k
	noremap <ESC>[6~ 10j
	noremap <PageUp> 10k
	noremap <PageDown> 10j
endfunction
" }}}
" InitCommonOptions() - init vim options {{{
function! InitCommonOptions()
	setlocal nowrap
	setlocal nonu
endfunction
" }}}
" InitColors() - init colors{{{
function! InitColors()
	syntax clear
	if s:use_colors
		syntax match OpsPath "^/.*"
		syntax match OpsNode "^\s*[+-]"
		syntax match OpsFile "^\s*\w\w*.*$"
		highlight link OpsPath Label
		highlight link OpsNode Comment
		highlight link OpsFile Question
	endif
endfunction
" }}}

" Opsplore(...) - start opsplorer {{{
function! Opsplore(...)
	" create explorer window
	" take argument as path, if given
	if a:0>0
		let path=a:1
	else
		" otherwise current dir
		let path=getcwd()
	endif
	" substitute leading ~
	" (doesn't work with isdirectory() otherwise!)
	let path=fnamemodify(path,":p")
	" expand, if relative path
	if path[0]!="/"
		let path=getcwd()."/".path
	endif
	" setup options
	call InitOptions()
	" create new window
	let splitcmd='new'
	if s:split_vertical
		let splitcmd='vne'
	endif
	let splitcmd=s:split_width.splitcmd
	execute splitcmd
	execute "setlocal wiw=".s:split_minwidth
	" remember buffer nr
	let s:window_bufnr=winbufnr(0)
	" setup mappings, apply options, colors and draw tree
	call InitCommonOptions()
	call InitMappings()
	call InitColors()
	call BuildTree(path)
	let g:opsplorer_loaded=1
endfunction
" }}}
" ToggleShowOpsplorer() - toggle opsplorer window{{{
function! ToggleShowOpsplorer()
	if exists("g:opsplorer_loaded")
		execute s:window_bufnr."bd"
		unlet g:opsplorer_loaded
	else
		call Opsplore()
	endif
endfunction
" }}}
" CloseOpsplorer() - close opsplorer window {{{
function! CloseOpsplorer()
	wincmd c
endfunction
" }}}

" BuildTree(path) - redraws the tree with basepath 'path' {{{
function! BuildTree(path)
	let path=a:path
	" clean up
	setlocal ma
	normal ggVGxo
	" check if no unneeded trailing / is there
	if strlen(path)>1&&path[strlen(path)-1]=="/"
		let path=strpart(path,0,strlen(path)-1)
	endif
	call setline(1,path)
	setlocal noma nomod
	" pass -1 as xpos to start at column 0
	call TreeExpand(-1,1,path)
	" move to first entry
	normal ggj1|g^
endfunction
" }}}
" BuildParentTree() - move to parent dir in basepath and select it {{{
function! BuildParentTree()
	normal gg$F/
	call OnDoubleClick(0)
endfunction
" }}}

" InsertFilename() - insert filename in edit buffer {{{
function! InsertFilename()
	normal 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	wincmd p
	execute "normal a".filename
endfunction
" }}}
" InsertFileContent() - insert content of file in edit buffer {{{
function! InsertFileContent()
	normal 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		wincmd p
		execute "r ".filename
	endif
endfunction
" }}}

" FileSee() - pass filename to linux 'see' command {{{
function! FileSee()
	normal 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let i=system("see ".filename."&")
	endif
endfunction
" }}}
" FileRename() - rename file {{{
function! FileRename()
	normal 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let newfilename=input("Rename to: ",filename)
		if filereadable(newfilename)
			if input("File exists, overwrite?")=~"^[yY]"
				setlocal ma
				let i=system("mv -f ".filename." ".newfilename)
				" refresh display
				normal gg$
				call OnDoubleClick(-1)
			endif
		else
			" rename file
			setlocal ma
			let i=system("mv ".filename." ".newfilename)
			normal gg$
			call OnDoubleClick(-1)
		endif
	endif
endfunction
" }}}
" FileMove() - move file {{{
function! FileMove()
	normal 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let newfilename=input("Move to: ",filename)
		if filereadable(newfilename)
			if input("File exists, overwrite?")=~"^[yY]"
				" move file
				let i=system("mv -f ".filename." ".newfilename)
				" refresh display
				normal gg$
				call OnDoubleClick(-1)
			endif
		else
			" move file
			let i=system("mv ".filename." ".newfilename)
			" refresh display
			normal gg$
			call OnDoubleClick(-1)
		endif
	endif
endfunction
" }}}
" FileCopy() - copy file {{{
function! FileCopy()
	normal 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let newfilename=input("Copy to: ",filename)
		if filereadable(newfilename)
			if input("File exists, overwrite?")=~"^[yY]"
				" copy file
				let i=system("cp -f ".filename." ".newfilename)
				" refresh display
				normal gg$
				call OnDoubleClick(-1)
			endif
		else
			" copy file
			let i=system("cp ".filename." ".newfilename)
			" refresh display
			normal gg$
			call OnDoubleClick(-1)
		endif
	endif
endfunction
" }}}
" FileDelete() - delete file {{{
function! FileDelete()
	normal 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		if input("OK to delete ".fnamemodify(filename,":t")."? ")[0]=~"[yY]"
			let i=system("rm -f ".filename)
			setlocal ma
			normal ddg^
			setlocal noma
		endif
	endif
endfunction
" }}}

" GotoNextNode() - move cursor to next node {{{
function! GotoNextNode()
	" in line 1 like next entry
	if line('.')==1
		call GotoNextEntry()
	else
		normal j1|g^
		while getline('.')[col('.')-1] !~ "[+-]" && line('.')<line('$')
			normal j1|g^
		endwhile
	endif
endfunction
" }}}
" GotoPrevNode() - move cursor to previous node {{{
function! GotoPrevNode()
	" entering base path section?
	if line('.')<3
		call GotoPrevEntry()
	else
		normal k1|g^
		while getline('.')[col('.')-1] !~ "[+-]" && line('.')>1
			normal k1|g^
		endwhile
	endif
endfunction
" }}}
" GotoNextEntry() - move cursor to next tree entry{{{
function! GotoNextEntry()
	let xpos=col('.')
	" different movement in line 1
	if line('.')==1
		" if over slash, move one to right
		if getline('.')[xpos-1]=='/'
			normal l
			" only root path there, move down
			if col('.')==1
				normal j1|g^
			endif
		else
			" otherwise after next slash
			normal f/l
			" if already last path, move down
			if col('.')==xpos
				normal j1|g^
			endif
		endif
	else
		" next line, first nonblank
		normal j1|g^
	endif
endfunction
" }}}
" GotoPrevEntry() - move cursor to previous tree entry{{{
function! GotoPrevEntry()
	" different movement in line 1
	if line('.')==1
		" move after prev slash
		normal hF/l
	else
		" enter line 1 at the end
		if line('.')==2
			normal k$F/l
		else
			" prev line, first nonblank
			normal k1|g^
		endif
	endif
endfunction
" }}}

" OnClick() - click action {{{
function! OnClick()
	let xpos=col('.')-1
	let ypos=line('.')
	if IsTreeNode(xpos,ypos)
		call TreeNodeAction(xpos,ypos)
	elsei s:single_click_to_edit
		call OnDoubleClick()
	endif
endfunction
" }}}
" OnDoubleClick(close_explorer) - doubleclick action {{{
function! OnDoubleClick(close_explorer)
	let s:close_explorer=a:close_explorer
	if s:close_explorer==-1
		let s:close_explorer=s:close_explorer_after_open
	endif
	let xpos=col('.')-1
	let ypos=line('.')
	" clicked on node
	if IsTreeNode(xpos,ypos)
		call TreeNodeAction(xpos,ypos)
	else
		" go to first non-blank when line>1
		if ypos>1
			normal 1|g^
			let xpos=col('.')-1
			" check, if it's a directory
			let path=GetPathName(xpos,ypos)
			if isdirectory(path)
				" build new root structure
				call BuildTree(path)
				execute "cd ".substitute(getline(1)," ",'\\ ',"g")
			else
				" try to resolve filename
				" and open in other window
				let path=GetPathName(xpos,ypos)
				if filereadable(path)
					" go to last accessed buffer
					wincmd p
					" append sequence for opening file
					execute "cd ".substitute(fnamemodify(path,":h")," ",'\\ ',"g")
					execute "e ".substitute(path," ",'\\ ',"g")
					setlocal ma
				endif
				if s:close_explorer==1
					call ToggleShowOpsplorer()
				endif
			endif
		else
			" we're on line 1 here! getting new base path now...
			" advance to next slash
			if getline(1)[xpos]!="/"
				normal f/
				" no next slash -> current directory, just rebuild
				if col('.')-1==xpos
					call BuildTree(getline(1))
					execute "cd ".getline(1)
					return
				endif
			endif
			" cut ending slash
			normal h
			" rebuild tree with new path
			call BuildTree(strpart(getline(1),0,col('.')))
		endif
	endif
endfunction
" }}}

" GetPathName(xpos,ypos) - try to get full pathname from file under cursor {{{
function! GetPathName(xpos,ypos)
	let xpos=a:xpos
	let ypos=a:ypos
	" check for directory..
	if getline(ypos)[xpos]=~"[+-]"
		let path='/'.strpart(getline(ypos),xpos+1,col('$'))
	else
		" otherwise filename
		let path='/'.strpart(getline(ypos),xpos,col('$'))
		let xpos=xpos-1
	endif
	" walk up tree and append subpaths
	let row=ypos-1
	let indent=xpos
	while indent>0
		" look for prev ident level
		let indent=indent-1
		while getline(row)[indent] != '-'
			let row=row-1
			if row == 0
				return ""
			endif
		endwhile
		" subpath found, append
		let path='/'.strpart(getline(row),indent+1,strlen(getline(row))).path
	endw 
	" finally add base path
	" not needed, if in root
	if getline(1)!='/'
		let path=getline(1).path
	endif
	return path
endfunction
" }}}
" TreeExpand(xpos,ypos,path) - expand tree at xpos/ypos, starting at path {{{
function! TreeExpand(xpos,ypos,path)
	let path=a:path
	setlocal ma
	" turn + into -
	normal r-
	" first get all subdirectories
	let dirlist=""
	" extra globbing for hidden files
	if s:show_hidden_files
		let dirlist=glob(path.'/.*')."\n"
	endif
	" add normal entries
	let dirlist=dirlist.glob(path.'/*')."\n"
	" remember where to append
	let row=a:ypos
	while strlen(dirlist)>0
		" get next line
		let entry=GetNextLine(dirlist)
		let dirlist=CutFirstLine(dirlist)
		" add to tree if directory
		if isdirectory(entry)
			let entry=substitute(entry,".*/",'','')
			if entry!="." && entry!=".."
				" indent, mark as node and append
				let entry=SpaceString(a:xpos+1)."+".entry
				call append(row,entry)
				let row=row+1
			endif
		endif
	endwhile
	" now get files
	let dirlist=""
	" extra globbing for hidden files
	if s:show_hidden_files
		let dirlist=glob(path.'/.*'.s:file_match_pattern)."\n"
	endif
	let dirlist=dirlist.glob(path.'/*'.s:file_match_pattern)."\n"
	while strlen(dirlist)>0
		" get next line
		let entry=GetNextLine(dirlist)
		let dirlist=CutFirstLine(dirlist)
		" only files
		if entry!="." && entry!=".." && entry!=""
			if !isdirectory(entry)&&filereadable(entry)
				let entry=substitute(entry,".*/",'','')
				" indent and append
				let entry=SpaceString(a:xpos+2).entry
				call append(row,entry)
				let row=row+1
			endif
		endif
	endwhile
	setlocal noma nomod
endfunction
" }}}
" TreeCollapse(xpos,ypos) - collapse tree at xpos/ypos {{{
function! TreeCollapse(xpos,ypos)
	setlocal ma
	" turn - into +, go to next line
	normal r+j
	" delete lines til next line with same indent
	while (getline('.')[a:xpos+1] =~ '[ +-]') && (line('$') != line('.'))
		normal dd
	endwhile
	" go up again
	normal k
	setlocal noma nomod
endfunction
" }}}
" TreeNodeAction(xpos,ypos) - treenode click action{{{
function! TreeNodeAction(xpos,ypos)
	if getline(a:ypos)[a:xpos] == '+'
		call TreeExpand(a:xpos,a:ypos,GetPathName(a:xpos,a:ypos))
	elsei getline(a:ypos)[a:xpos] == '-'
		call TreeCollapse(a:xpos,a:ypos)
	endif
endfunction
" }}}
" IsTreeNode(xpos,ypos) - check if xpos/ypos is a treenode {{{
function! IsTreeNode(xpos,ypos)
	if getline(a:ypos)[a:xpos] =~ '[+-]'
		" is it a directory or file starting with +/- ?
		if isdirectory(GetPathName(a:xpos,a:ypos))
			return 1
		else
			return 0
		endif
	else
		return 0
	endif
endfunction
" }}}
" ToggleShowHidden() - toggle display of hidden files {{{
function! ToggleShowHidden()
	let s:show_hidden_files = 1-s:show_hidden_files
	call BuildTree(getline(1))
endfunction
" }}}
" SetMatchPattern() - set file match pattern for display {{{
function! SetMatchPattern()
	let s:file_match_pattern=input("Match pattern: ",s:file_match_pattern)
	call BuildTree(getline(1))
endfunction
" }}}
" GetNextLine(text) - return the first line from a text {{{
function! GetNextLine(text)
	let pos=match(a:text,"\n")
	return strpart(a:text,0,pos)
endfunction
" }}}
" CutFirstLine(text) - cut the first line from a text {{{
function! CutFirstLine(text)
	let pos=match(a:text,"\n")
	return strpart(a:text,pos+1,strlen(a:text))
endfunction
" }}}
" SpaceString(width) - return string with 'width' spaces {{{
function! SpaceString(width)
	let spacer=""
	let width=a:width
	while width>0
		let spacer=spacer." "
		let width=width-1
	endwhile
	return spacer
endfunction
" }}}


