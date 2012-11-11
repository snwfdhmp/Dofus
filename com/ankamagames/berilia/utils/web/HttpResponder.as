﻿package com.ankamagames.berilia.utils.web
{
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;
    import flash.utils.*;

    public class HttpResponder extends Object
    {
        private var _socket:Socket;
        private var _responseBytes:ByteArray;
        private var _contentBytes:ByteArray;
        private var _stream:FileStream;
        private var _mimeHeader:String;
        private var _statusHeader:String;
        private var _dateHeader:String;
        private var _contentLengthHeader:String;
        private var _includeContent:Boolean = true;
        private const HEADER_SEPERATOR:String = "\n";
        private const HEADER_END_SEPERATOR:String = "\n\n";
        private static const HTTP_VERB_GET:String = "GET";
        private static const HTTP_VERB_HEAD:String = "HEAD";
        private static const HTTP_VERB_POST:String = "POST";

        public function HttpResponder(param1:Socket, param2:String, param3:String, param4:String)
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            this._socket = param1;
            if (param2 != HttpResponder.HTTP_VERB_GET && param2 != HttpResponder.HTTP_VERB_HEAD)
            {
                this.throw501();
            }
            if (param2 == HttpResponder.HTTP_VERB_HEAD)
            {
                this._includeContent = false;
            }
            this._responseBytes = new ByteArray();
            if (param3.indexOf("?") != -1)
            {
                param3 = param3.substring(0, param3.indexOf("?"));
            }
            param3 = decodeURI(param3);
            if (param3.indexOf("../") != -1 || param3.indexOf("..\\") != -1)
            {
                this.throw403();
            }
            while (param3.charAt(0) == ".")
            {
                
                param3 = param3.substr(1);
            }
            while (param3.charAt(0) == "/")
            {
                
                param3 = param3.substr(1);
            }
            var _loc_5:* = new File(param4);
            if (new File(param4).exists)
            {
                _loc_6 = _loc_5.resolvePath(param3);
                if (_loc_6.exists)
                {
                    if (_loc_6.isDirectory)
                    {
                        this._dateHeader = "Date: " + this.toRFC802(new Date());
                        this._mimeHeader = "Content-Type: text/html";
                        _loc_6.addEventListener(FileListEvent.DIRECTORY_LISTING, this.onDirectoryList);
                        _loc_6.getDirectoryListingAsync();
                    }
                    else
                    {
                        trace(_loc_6.nativePath);
                        _loc_7 = _loc_6.modificationDate;
                        this._dateHeader = "Date: " + this.toRFC802(_loc_7);
                        this._mimeHeader = this.getMimeHeader(_loc_6);
                        this._stream = new FileStream();
                        this._stream.addEventListener(Event.COMPLETE, this.onFileReadDone);
                        this._stream.addEventListener(IOErrorEvent.IO_ERROR, this.onFileIoError);
                        this._stream.openAsync(_loc_6, FileMode.READ);
                    }
                }
                else
                {
                    this.throw404();
                }
            }
            else
            {
                this.throw404();
            }
            return;
        }// end function

        private function onFileIoError(event:Event) : void
        {
            this._stream.removeEventListener(Event.COMPLETE, this.onFileReadDone);
            this._stream.removeEventListener(IOErrorEvent.IO_ERROR, this.onFileIoError);
            this._stream.close();
            this._dateHeader = null;
            this.throw404();
            return;
        }// end function

        private function onFileReadDone(event:Event) : void
        {
            this._stream.removeEventListener(Event.COMPLETE, this.onFileReadDone);
            this._stream.removeEventListener(IOErrorEvent.IO_ERROR, this.onFileIoError);
            this._contentBytes = new ByteArray();
            this._stream.readBytes(this._contentBytes, 0, this._stream.bytesAvailable);
            this._stream.close();
            this._statusHeader = "HTTP/1.0 200 OK";
            this._contentBytes.position = 0;
            this._contentLengthHeader = "Content-Length: " + this._contentBytes.bytesAvailable;
            this.sendResponse();
            return;
        }// end function

        private function getRelativePath(param1:File) : String
        {
            var _loc_2:* = new File(HttpServer.getInstance().rootPath).nativePath;
            return param1.nativePath.substring((_loc_2.length + 1)).split("\\").join("/");
        }// end function

        private function getImg(param1:File) : String
        {
            var _loc_2:* = "<img src=\"data:image/png;base64,";
            if (param1.isDirectory)
            {
                _loc_2 = _loc_2 + "iVBORw0KGgoAAAANSUhEUgAAAA4AAAALCAYAAABPhbxiAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH1gcFERo3mDnvIwAAAYBJREFUeNp9j71qFVEUhb9zcu44inMJKKJBEaxugqUEhHT6HjY+gI1YCIKN4BNYCj6CWIr4CMFKERuDmMSfO3P/MnP+lsWMuVauZm8Wa+21l/n05tZ+Od7ZMcayhujmXw5SrG8DHf/CALB0RnZybe/lyBgD6k0YQ2x/3jjaf3qggQXYKMZSCseL7+8eOqJasj/THb4g+Q2wY4ypKLfusLX7vEACMigDwtjzlz+/3nviCMYqe5IvUBb55CthecTi+D2j8gooQPZIEYhUk0cFytcdRmWOJ/gVyC8J8xnV5B7lhe2h0N9E9YluE5J1jmBxZy+xuX3/VCAy2X8j1m9RalBsUJyhtKC8+hg64QiSUktefehFaY5iTQ5TlBqI9cDPUFqCOgjg6JByJIcf/eXUoFgP+3RImp0apQgdOLxkSCj+Hgz1+r3UoDhfm3Lb14ng5PM0rn6dC4uiIldWGkGuQBdR6gCPbD+NTaS2lXzuzMdnNx9gzS7iLoaK/0GAwZP16g/A9xHVPFbSAQAAAABJRU5ErkJggg%3D%3D";
            }
            else
            {
                switch(param1.extension)
                {
                    case "swf":
                    case "swfs":
                    {
                        _loc_2 = _loc_2 + "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHYSURBVDjLjZPLSxtRFMa1f0UXCl0VN66igg80kQZtsLiUWhe14MKFIFHbIEF8BNFFKYVkkT9GKFJooXTToq2gLkQT82oyjzuvO8nXe65mmIkRHfg2c+/3O+d8l9MBoIMkvi6hkNDAA3om9MTz+QAhy7JqnPO667poJ3GOdDr92Q/xAwbIrOs6GGOeFEVBtVpFoVCQkHw+j0wm40Ga5k4C0AXTNGHbNsxv32Hu7YNtp1Cr1VAsFiXAMAxQkWw2ewNpBZDZPjiA+XYebioJ9nIKqqqiVCrdGUlm0gpwzs5hzrwGX1uGMTMLtvrBG6VcLstOcrncPQDOYW3tgCffw0isg4uqnP6J8AhCnVAelUqlPYD/PYE59wZ67BXsL4fg/6ryYhNC82uaJkFtAdbHT+CJFbgbCagjYbDNlDev4zgyH4KQ7gA2n/fMUWWeiAtzBMrgWABAXciAhaibAKAYnXyaGx3/5cSXoIajsH/8hHP8B87llTSSqAMSmQMAfSL2VYtET5WRCLcW3oHt7Aaq+s1+eQAt/EJXh8MNe2kRSmwa/LoQeOsmpFUeQB0ag9I/jIve0G/n6Lhx3x60Ud3L4DbIPhEQo4PHmMVdTW6vD9BNkEesc1O0+t3/AXamvvzW7S+UAAAAAElFTkSuQmCC";
                        break;
                    }
                    case "png":
                    case "jpg":
                    case "jpeg":
                    {
                        _loc_2 = _loc_2 + "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHfSURBVDjLpZO9a5NhFMV/bxowYvNRjf1IoCDo0KFJBVHEVbeCi5N/gM6KruLi6KiDKA6KIC6CQwdtBxfRrUGHFlTQIlikjTFpkua55zo8r7aDipALd3keOOdwzrmJuzPMZF/cOPFXBMmRHJMTTJiJYCIEESy+ZQGqczPIDNxxd/AMDriBu+MSCkJmSA4CJ8Pym+UIIAs0177S3Wz9F3O+WGCiMrmjwM3pbrZ4fvo17kR237XAtcolRvdOA+L+9TscHB/HTGQAlLqwuHWbxa1b9JMVTBDSHRi82qijbgPXNsGEpx5kouYo+2jpI/3kCUudiwzUJBgMAoQAjf4ZFtZP0mq/x0xIYPJUQQoQLHAsX8fMeNk7y4DVCGKw0q7ytHmByx/u/lYgOVnJUbBomAa8azWYr5b50unRGZln48ccYzrH5/VTtHuTKIxQk8dUdgMEE/XyN2YPTFHJHaZWFPIan/KriEccqT5ExJi15FiwWCSTo+CYiYk9h5CL4NvIhSOmctOxCwgh3J3vauAWnc8GEzInt2+U3s1nuEWwmPlOByzthuSUSyV+XUDWTOAJxbEyhcJ+pPgxc/4KnbUFQOTKx3n74B5uQhI4JEkMMHl8ddZ3d/tfzH+aZNhrzDDk/ARfG6G/LNZPQgAAAABJRU5ErkJggg==";
                        break;
                    }
                    case "xml":
                    case "meta":
                    case "metas":
                    {
                        _loc_2 = _loc_2 + "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAADoSURBVBgZBcExblNBGAbA2ceegTRBuIKOgiihSZNTcC5LUHAihNJR0kGKCDcYJY6D3/77MdOinTvzAgCw8ysThIvn/VojIyMjIyPP+bS1sUQIV2s95pBDDvmbP/mdkft83tpYguZq5Jh/OeaYh+yzy8hTHvNlaxNNczm+la9OTlar1UdA/+C2A4trRCnD3jS8BB1obq2Gk6GU6QbQAS4BUaYSQAf4bhhKKTFdAzrAOwAxEUAH+KEM01SY3gM6wBsEAQB0gJ+maZoC3gI6iPYaAIBJsiRmHU0AALOeFC3aK2cWAACUXe7+AwO0lc9eTHYTAAAAAElFTkSuQmCC";
                        break;
                    }
                    default:
                    {
                        _loc_2 = _loc_2 + "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAC4SURBVCjPdZFbDsIgEEWnrsMm7oGGfZrohxvU+Iq1TyjU60Bf1pac4Yc5YS4ZAtGWBMk/drQBOVwJlZrWYkLhsB8UV9K0BUrPGy9cWbng2CtEEUmLGppPjRwpbixUKHBiZRS0p+ZGhvs4irNEvWD8heHpbsyDXznPhYFOyTjJc13olIqzZCHBouE0FRMUjA+s1gTjaRgVFpqRwC8mfoXPPEVPS7LbRaJL2y7bOifRCTEli3U7BMWgLzKlW/CuebZPAAAAAElFTkSuQmCC";
                        break;
                    }
                }
            }
            return _loc_2 + "\" />";
        }// end function

        private function onDirectoryList(event:FileListEvent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = false;
            this._statusHeader = "HTTP/1.0 200 OK";
            var _loc_2:* = "<html><head><title>Dofus Module Server</title></head><body><h2>Index of /" + this.getRelativePath(File(event.target)) + "</h2><ul>";
            _loc_2 = _loc_2 + "<table><tr><td></td><td><b>Name</b></td><td><b>Last modified</b></td><td><b>Size (octet)</b></td></tr>";
            if (this.getRelativePath(File(event.target)) != "")
            {
                _loc_2 = _loc_2 + ("<tr><td>" + this.getImg(File(event.target).parent) + "</td><td><a href=\"" + HttpServer.getInstance().getUrlTo(this.getRelativePath(File(event.target).parent)) + "\">..</a></td><td>-</td><td>-</td></tr>");
            }
            for each (_loc_3 in event.files)
            {
                
                _loc_4 = _loc_3.isDirectory;
                _loc_2 = _loc_2 + ("<tr>" + "<td>" + this.getImg(_loc_3) + "</td>" + "<td><a href=\"" + HttpServer.getInstance().getUrlTo(this.getRelativePath(_loc_3)) + "\">" + _loc_3.name + (_loc_4 ? ("/") : ("")) + "</a></td>" + "<td>" + this.toRFC802(_loc_3.modificationDate) + "</td>" + "<td>" + (_loc_4 ? ("-") : (_loc_3.size)) + "</td>" + "</tr>");
            }
            _loc_2 = _loc_2 + "</table></body></html>";
            this._contentBytes = new ByteArray();
            this._contentBytes.writeUTFBytes(_loc_2);
            this._contentBytes.position = 0;
            this._contentLengthHeader = "Content-Length: " + this._contentBytes.bytesAvailable;
            this.sendResponse();
            return;
        }// end function

        private function sendResponse() : void
        {
            this._responseBytes = new ByteArray();
            this._responseBytes.writeUTFBytes(this._statusHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_SEPERATOR);
            if (this._dateHeader)
            {
                this._responseBytes.writeUTFBytes(this._dateHeader);
                this._responseBytes.writeUTFBytes(this.HEADER_SEPERATOR);
            }
            this._responseBytes.writeUTFBytes(this._mimeHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_SEPERATOR);
            if (this._includeContent)
            {
                this._responseBytes.writeUTFBytes(this._contentLengthHeader);
            }
            this._responseBytes.writeUTFBytes(this.HEADER_END_SEPERATOR);
            if (this._includeContent)
            {
                this._responseBytes.writeBytes(this._contentBytes);
            }
            this._responseBytes.position = 0;
            this._socket.writeBytes(this._responseBytes, 0, this._responseBytes.bytesAvailable);
            this._socket.flush();
            return;
        }// end function

        private function throw404() : void
        {
            this._statusHeader = "HTTP/1.0 404 Not Found";
            this._mimeHeader = "Content-Type: text/html";
            var _loc_1:* = "<HTML><HEAD><TITLE>404 Not Found</TITLE></HEAD><BODY>404 Not Found</BODY></HTML>";
            this._contentBytes = new ByteArray();
            this._contentBytes.writeUTFBytes(_loc_1);
            this._contentBytes.position = 0;
            this._contentLengthHeader = "Content-Length: " + this._contentBytes.bytesAvailable;
            this.sendResponse();
            return;
        }// end function

        private function throw403() : void
        {
            this._statusHeader = "HTTP/1.0 403 Forbidden";
            this._mimeHeader = "Content-Type: text/html";
            var _loc_1:* = "<HTML><HEAD><TITLE>403 Forbidden</TITLE></HEAD><BODY>403 Forbidden</BODY></HTML>";
            this._contentBytes = new ByteArray();
            this._contentBytes.writeUTFBytes(_loc_1);
            this._contentBytes.position = 0;
            this._contentLengthHeader = "Content-Length: " + this._contentBytes.bytesAvailable;
            this.sendResponse();
            return;
        }// end function

        private function throw501() : void
        {
            this._statusHeader = "HTTP/1.0 501 Not Implemented";
            this._responseBytes = new ByteArray();
            this._responseBytes.writeUTFBytes(this._statusHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_END_SEPERATOR);
            this._responseBytes.position = 0;
            this._socket.writeBytes(this._responseBytes, 0, this._responseBytes.bytesAvailable);
            return;
        }// end function

        private function throw500() : void
        {
            this._statusHeader = "HTTP/1.0 500 Internal Server Error";
            this._responseBytes = new ByteArray();
            this._responseBytes.writeUTFBytes(this._statusHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_END_SEPERATOR);
            this._responseBytes.position = 0;
            this._socket.writeBytes(this._responseBytes, 0, this._responseBytes.bytesAvailable);
            return;
        }// end function

        private function getMimeHeader(param1:File) : String
        {
            var _loc_2:* = param1.extension;
            return "Content-Type: " + MimeTypeHelper.getMimeType(_loc_2);
        }// end function

        private function toRFC802(param1:Date) : String
        {
            var _loc_2:* = "";
            switch(param1.dayUTC)
            {
                case 0:
                {
                    _loc_2 = _loc_2 + "Sun";
                    break;
                }
                case 1:
                {
                    _loc_2 = _loc_2 + "Mon";
                    break;
                }
                case 2:
                {
                    _loc_2 = _loc_2 + "Tue";
                    break;
                }
                case 3:
                {
                    _loc_2 = _loc_2 + "Wed";
                    break;
                }
                case 4:
                {
                    _loc_2 = _loc_2 + "Thu";
                    break;
                }
                case 5:
                {
                    _loc_2 = _loc_2 + "Fri";
                    break;
                }
                case 6:
                {
                    _loc_2 = _loc_2 + "Sat";
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_2 = _loc_2 + ", ";
            if (param1.dateUTC < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.dateUTC + " ");
            switch(param1.month)
            {
                case 0:
                {
                    _loc_2 = _loc_2 + "Jan";
                    break;
                }
                case 1:
                {
                    _loc_2 = _loc_2 + "Feb";
                    break;
                }
                case 2:
                {
                    _loc_2 = _loc_2 + "Mar";
                    break;
                }
                case 3:
                {
                    _loc_2 = _loc_2 + "Apr";
                    break;
                }
                case 4:
                {
                    _loc_2 = _loc_2 + "May";
                    break;
                }
                case 5:
                {
                    _loc_2 = _loc_2 + "Jun";
                    break;
                }
                case 6:
                {
                    _loc_2 = _loc_2 + "Jul";
                    break;
                }
                case 7:
                {
                    _loc_2 = _loc_2 + "Aug";
                    break;
                }
                case 8:
                {
                    _loc_2 = _loc_2 + "Sep";
                    break;
                }
                case 9:
                {
                    _loc_2 = _loc_2 + "Oct";
                    break;
                }
                case 10:
                {
                    _loc_2 = _loc_2 + "Nov";
                    break;
                }
                case 11:
                {
                    _loc_2 = _loc_2 + "Dec";
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_2 = _loc_2 + " ";
            _loc_2 = _loc_2 + (param1.fullYearUTC + " ");
            if (param1.hoursUTC < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.hoursUTC + ":");
            if (param1.minutesUTC < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.minutesUTC + ":");
            if (param1.seconds < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.secondsUTC + " GMT");
            return _loc_2;
        }// end function

    }
}
