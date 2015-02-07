/ \[my\.javac\] .*\.java:[0-9]\+:.*/{
/ warning: /d
}
/ \[my\.javac\] .*\.java:[0-9]\+:.*/{
s/\/output\/android\/src//
p
}
/\[my\.breamc\] .*.bream:[0-9]\+:[0-9]\+: error: */p
/\[my\.breamc\] error: .*/p
/\[my\.breamc\] .*.bream:[0-9]\+:[0-9]\+: warning: */p
/     \[exec\] .*.xml:[0-9]\+: error: */p
