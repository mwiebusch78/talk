%% talk -- (talk.cls) Class file%% A LaTeX class for creating presentations
%% Author: Martin Wiebusch
%%
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2003/12/01 or later.


\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{talk}[2006/07/11 v1.1]

\def\talk@dt@notes{notes}
\def\talk@dt@slides{slides}
\def\talk@dt@screen{screen}
\def\talk@doctype{}
\newif\if@talk@rotate

\def\@ifnotes#1#2{\ifx\talk@doctype\talk@dt@notes#1\else#2\fi}
\def\@ifslides#1#2{\ifx\talk@doctype\talk@dt@slides#1\else#2\fi}
\def\@ifscreen#1#2{\ifx\talk@doctype\talk@dt@screen#1\else#2\fi}

\DeclareOption{notes}{\global\let\talk@doctype\talk@dt@notes}
\DeclareOption{slides}{\global\let\talk@doctype\talk@dt@slides}
\DeclareOption{screen}{\global\let\talk@doctype\talk@dt@screen}
\DeclareOption{rotate}{\@talk@rotatetrue}
\DeclareOption{norotate}{\@talk@rotatefalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ExecuteOptions{screen,rotate}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{multido}
\RequirePackage{graphicx}
\RequirePackage{pgf}
\RequirePackage{xstring}
\RequirePackage{environ}


% shiftbox macro for positioning
%
\newcommand{\shiftbox}[4][lB]{%
  \setbox\@tempboxa\hbox{#4}%
  \@tempdima=#2%
  \@tempdimb=#3%
  \IfSubStr{#1}{r}{\advance\@tempdima-\wd\@tempboxa}{}%
  \IfSubStr{#1}{t}{\advance\@tempdimb-\ht\@tempboxa}{}%
  \IfSubStr{#1}{b}{\advance\@tempdimb\dp\@tempboxa}{}%
  \setbox\@tempboxa\hbox{\kern\@tempdima\raise\@tempdimb\box\@tempboxa}%
  \wd\@tempboxa=\z@%
  \ht\@tempboxa=\z@%
  \dp\@tempboxa=\z@%
  \leavevmode%
  \box\@tempboxa%
}

% title and author
%
\def\title{\@ifnextchar[{\talk@titleii}{\talk@titlei}}
\def\talk@titleii[#1]#2{\gdef\@title{#2}\gdef\@shorttitle{#1}}
\def\talk@titlei#1{\talk@titleii[#1]{#1}}
\def\author{\@ifnextchar[{\talk@authorii}{\talk@authori}}
\def\talk@authorii[#1]#2{\gdef\@author{#2}\gdef\@shortauthor{#1}}
\def\talk@authori#1{\talk@authorii[#1]{#1}}

% some definitions
%
\newlength{\slidewidth}
\newlength{\slideheight}
\newlength{\talk@hadjust}
\newlength{\talk@vadjust}
\def\talk@currentslidestyle{}
\def\talk@oldslidestyle{}
\def\@slidetitle{}
\def\@slidebody{}
\long\def\talk@defslidebody#1{\long\gdef\@slidebody{#1}}
\def\talk@slidesmag{1}


% section and subsection handling
%
\long\def\@tableofcontents{}
\newcommand{\talk@artsection}[2][]{}
\newcommand{\talk@artsubsection}[2][]{}
\@ifnotes{%
  \let\talk@artsection\section
  \let\talk@artsubsection\subsection
}{}
\def\talk@addtocsection#1#2#3{%
  \expandafter\gdef\expandafter\@tableofcontents\expandafter{\@tableofcontents\@maketocsection{#1}{#2}{#3}}%
}
\def\talk@addtocsubsection#1#2#3#4{%
  \expandafter\gdef\expandafter\@tableofcontents\expandafter{\@tableofcontents\@maketocsubsection{#1}{#2}{#3}{#4}}%
}
\def\section{\@ifnextchar[{\@@talk@section}{\@talk@section}}
\def\@talk@section#1{\@@talk@section[#1]{#1}}
\def\@@talk@section[#1]#2{%
  \talk@artsection[#1]{#2}
  \@ifnotes{}{\refstepcounter{section}}
  \addtocontents{ttc}{\string\talk@addtocsection{\the\c@section}{#1}{#2}}
}
\def\subsection{\@ifnextchar[{\@@talk@subsection}{\@talk@subsection}}
\def\@talk@subsection#1{\@@talk@subsection[#1]{#1}}
\def\@@talk@subsection[#1]#2{%
  \talk@artsubsection[#1]{#2}
  \@ifnotes{}{\refstepcounter{subsection}}
  \addtocontents{ttc}{\string\talk@addtocsubsection{\the\c@section}{\the\c@subsection}{#1}{#2}}
}
\long\def\@ifcurrentsection#1#2#3{\ifnum\c@section=#1 #2\else#3\fi}
\long\def\@ifcurrentsubsection#1#2#3{\ifnum\c@subsection=#1 #2\else#3\fi}
\@input{\jobname.ttc}%
\newwrite\tf@ttc
\immediate\openout\tf@ttc\jobname.ttc\relax
\newwrite\tf@toc
\immediate\openout\tf@toc\jobname.toc\relax


% table of contents
%
\long\def\maketitle{}
\long\def\tableofcontents{}
\long\def\talk@ifinrange#1#2[#3.#4-#5.#6]#7#8{%
  \ifnum#1=#3
    \ifnum#2<#4 #8\else #7\fi
  \else
    \ifnum#1=#5
      \ifnum#2>#6 #8\else #7\fi
    \else
      \ifnum#1<#3 #8\else
        \ifnum#1>#5 #8\else #7\fi
      \fi
    \fi
  \fi
}
\long\def\@ifinrange#1#2#3#4#5{\talk@ifinrange{#1}{#2}[#3]{#4}{#5}}


% default make commands
%
\long\def\talk@defaultslide{%
  \vspace*{1.2em minus 0.4em}%
  \centerline{\LARGE\@slidetitle}%
  \vspace*{1.8em minus 0.6em}%
  \@slidebody%
  \vfill%
  \raggedleft\tiny\@title\ -- \theslidelabel%
}
\def\talk@restoredefaults{%
  \gdef\@makeslidecontent{\talk@defaultslide}
  \gdef\@makeslidebackground{\talk@defaultslidebackground}
  \gdef\@makeslide{\talk@defaultslide}
  \gdef\@makenotesslide{\par\hspace*{\fill}\@slidebox\hspace*{\fill}\par}
  \gdef\@maketocsection##1##2##3{}
  \gdef\@maketocsubsection##1##2##3##4{}
}
\talk@restoredefaults


% the slide environment
%
\def\talk@slidebox{\raisebox\slideheight{\@makeslide}\kern\slidewidth}

\def\@slidebox{%
  \@ifslides{%
    \scalebox{\talk@slidesmag}{%
      \if@talk@rotate
        \rotatebox[origin = bl]{90}{\talk@slidebox}%
      \else%
        \talk@slidebox%
      \fi%
    }%
  }{%
    \talk@slidebox%
  }%
}

\@ifnotes{\def\talk@makeslide{\noindent\@makenotesslide}}{}
\@ifslides{%
  \def\talk@makeslide{%
    \vspace*{\fill}%
    \vspace{2\talk@vadjust}
    \noindent%
    \hspace*{\fill}%
    \hspace{2\talk@hadjust}
    \@slidebox%
    \hspace*{\fill}%
    \vspace*{\fill}%
    \newpage%
  }%
}{}
\@ifscreen{\def\talk@makeslide{%
    \noindent\@slidebox%
    \newpage%
}}{}

\environbodyname\@slidebody
\NewEnviron{slide}[2][\@empty]{%
  \refstepcounter{slide}%
  \ifx#1\@empty%
    \csname talk@sty@\talk@currentslidestyle\endcsname%
  \else%
    \csname talk@sty@#1\endcsname%
  \fi%
  \long\global\def\@slidetitle{#2}%
  \global\@ignoretrue%
  \talk@makeslide%
}
\environbodyname\BODY


% slide styles
%
\long\def\@newslidestyle#1#2{%
  \edef\@temp{#1}%
  \expandafter\gdef\csname talk@sty@\@temp\endcsname{%
    \talk@restoredefaults%
    #2%
  }%
}
\newcommand{\slidestyle}[1]{\gdef\talk@currentslidestyle{#1}}


% slide and subslide numbering
%
\newcounter{slide}
\newcounter{subslide}
\def\theslide{\arabic{slide}}
\def\thesubslide{\theslide.\arabic{subslide}}
\def\theHsubslide{\thesubslide}
\def\theslidelabel{\theslide}

% overlay commands
%
\@ifnotes{
  \long\gdef\fromslide{\@ifnextchar*{\@fromslidestar}{\@fromslide}}
  \long\gdef\@fromslide#1#2{#2}
  \long\gdef\@fromslidestar*#1#2{#2}
  \long\gdef\toslide{\@ifnextchar*{\@toslidestar}{\@toslide}}
  \long\gdef\@toslide#1#2{#2}
  \long\gdef\@toslidestar*#1#2{#2}
  \long\gdef\onlyslide{\@ifnextchar*{\@onlyslidestar}{\@onlyslide}}
  \long\gdef\@onlyslide#1#2{#2}
  \long\gdef\@onlyslidestar*#1#2{#2}
  \gdef\talk@makemultislide{\talk@makeslide}
}{%
  \long\gdef\fromslide{\@ifnextchar*{\@fromslidestar}{\@fromslide}}
  \long\gdef\@fromslide#1#2{%
    \ifnum\c@subslide<#1%
      \pgfsys@begininvisible#2\pgfsys@endinvisible%
    \else%
      #2%
    \fi%
  }
  \long\gdef\@fromslidestar*#1#2{%
    \ifnum\c@subslide<#1%
    \else%
      #2%
    \fi%
  }
  \long\gdef\toslide{\@ifnextchar*{\@toslidestar}{\@toslide}}
  \long\gdef\@toslide#1#2{%
    \ifnum\c@subslide>#1%
      \pgfsys@begininvisible#2\pgfsys@endinvisible%
    \else%
      #2%
    \fi%
  }
  \long\gdef\@toslidestar*#1#2{%
    \ifnum\c@subslide>#1\relax%
    \else%
      #2%
    \fi%
  }
  \long\gdef\onlyslide{\@ifnextchar*{\@onlyslidestar}{\@onlyslide}}
  \long\gdef\@onlyslide#1#2{%
    \ifnum\c@subslide=#1\relax%
      #2%
    \else%
      \pgfsys@begininvisible#2\pgfsys@endinvisible%
    \fi%
  }
  \long\gdef\@onlyslidestar*#1#2{%
    \ifnum\c@subslide=#1\relax%
      #2%
    \fi%
  }
}
\@ifslides{%
  \def\talk@makemultislide{%
    \setcounter{subslide}{0}%
    \def\theslidelabel{\thesubslide}
    \multido{}{\talk@msmax}{%
      \refstepcounter{subslide}%
      \vspace*{\fill}%
      \noindent%
      \hspace*{\fill}%
      \@slidebox%
      \hspace*{\fill}%
      \vspace*{\fill}%
      \newpage%
    }%
  }%
}{}
\@ifscreen{%
  \def\talk@makemultislide{%
    \setcounter{subslide}{0}%
    \def\theslidelabel{\thesubslide}
    \multido{}{\talk@msmax}{%
      \refstepcounter{subslide}
      \noindent\@slidebox%
      \newpage%
    }%
  }%
}{}

\environbodyname\@slidebody
\NewEnviron{multislide}[3][\@empty]{%
  \refstepcounter{slide}%
  \ifx#1\@empty%
    \csname talk@sty@\talk@currentslidestyle\endcsname%
  \else%
    \csname talk@sty@#1\endcsname%
  \fi%
  \long\global\def\@slidetitle{#3}%
  \global\def\talk@msmax{#2}%
  \global\@ignoretrue%
  \talk@makemultislide%
}
\environbodyname\BODY

% notes
%
\NewEnviron{notes}{\@ifnotes{\BODY}{}}

% size settings
%
\AtBeginDocument{%
  \AtBeginDvi{\special{papersize=\the\paperwidth,\the\paperheight}}%
}
\def\talk@removemargins{%
  \setlength\oddsidemargin{-1in}%
  \setlength\evensidemargin{-1in}%
  \setlength\topmargin{-1in}%
  \setlength\headheight\z@%
  \setlength\headsep\z@%
  \setlength\topskip\z@%
  \setlength\footskip\z@%
  \setlength\textwidth\paperwidth%
  \setlength\textheight\paperheight%
}
\def\@slidesize#1#2{
  \setlength\slidewidth{#1}
  \setlength\slideheight{#2}
  \@ifscreen{%
    \setlength\paperwidth\slidewidth%
    \setlength\paperheight\slideheight%
    \talk@removemargins%
  }{}%
  \@ifslides{\talk@removemargins}{}%
}
\def\slidesmag#1{\gdef\talk@slidesmag{#1}}
\def\slidesadjust#1#2{%
  \if@talk@rotate
    \setlength{\talk@hadjust}{#2}%
    \setlength{\talk@vadjust}{#1}%
    \setlength{\talk@vadjust}{-\talk@vadjust}%
  \else
    \setlength{\talk@hadjust}{#1}%
    \setlength{\talk@vadjust}{#2}%
  \fi
}

\@slidesize{4in}{3in}
\@ifnotes{}{\pagestyle{empty}}


% footnote style
%
\def\thempfootnote{\@arabic\c@mpfootnote}
\let\thanks\footnote

