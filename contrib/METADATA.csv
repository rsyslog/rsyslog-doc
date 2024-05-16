Metadata that can be used in Rsyslog (8.2402+):


filename, metadata, imfile, Name of the file where the message originated from. This is most useful when using wildcards inside file monitors because it then is the only way to know which file the message originated from. The value can be accessed using the %$!metadata!filename% property. Note: For symlink-ed files this does not contain name of the actual file (source of the data) but name of the symlink (file which matched configured input).
fileoffset, metadata, imfile, Offset of the file in bytes at the time the message was read. The offset reported is from the start of the line. This information can be useful when recreating multi-line files that may have been accessed or transmitted non-sequentially. The value can be accessed using the %$!metadata!fileoffset% property.
Id, metadata, imdocker, the container id associated with the message.
ImageID, metadata, imdocker, the image id of the container associated with the message.
Labels, metadata, imdocker, all the labels of the container associated with the message in json format.
Names, metadata, imdocker, the first container associated with the message.
parsesuccess, metadata, mmjsonparse, 
mmcount, metadata, mmcount, number of messages counted
app-name, metadata, mmcount, name of the app that this message is counted by.
msg, metadata, ommail,  RFC822 body payload, extract message via template's msg.
$!docker!id
$!kubernetes!annotations
$!kubernetes!container\_name
$!kubernetes!creation\_timestamp
$!kubernetes!host
$!kubernetes!labels
$!kubernetes!master\_url
$!kubernetes!namespace\_id
$!kubernetes!namespace\_labels
$!kubernetes!namespace\_annotations
$!kubernetes!namespace\_name
$!kubernetes!pod\_id
$!kubernetes!pod\_name
