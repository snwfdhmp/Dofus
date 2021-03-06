﻿package com.ankamagames.jerakine.eval
{
    import com.ankamagames.jerakine.logger.Logger;
    import com.ankamagames.jerakine.logger.Log;
    import flash.utils.getQualifiedClassName;

    public class Evaluator 
    {

        protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Evaluator));
        private static const NUMBER:uint = 0;
        private static const STRING:uint = 1;


        public function eval(expr:String)
        {
            return (this.complexEval(expr));
        }

        private function simpleEval(expr:String)
        {
            var operator:Function;
            var currentChar:String;
            var partialOp:Array;
            var lastOp:*;
            var _local_15:Boolean;
            var _local_16:Boolean;
            var k:uint;
            var currentOperator:String = "";
            var inQuote:Boolean;
            var protect:Boolean;
            var currentParam:String = "";
            var currentType:uint = STRING;
            var op:Array = new Array();
            var i:uint;
            while (i < expr.length)
            {
                currentChar = expr.charAt(i);
                if ((((currentChar == "'")) && (!(protect))))
                {
                    currentType = STRING;
                    inQuote = !(inQuote);
                }
                else
                {
                    if (currentChar == "\\")
                    {
                        protect = true;
                    }
                    else
                    {
                        if (!(inQuote))
                        {
                            switch (currentChar)
                            {
                                case "(":
                                case ")":
                                case " ":
                                case "\t":
                                case "\n":
                                    break;
                                case "0":
                                case "1":
                                case "2":
                                case "3":
                                case "4":
                                case "5":
                                case "6":
                                case "7":
                                case "8":
                                case "9":
                                    currentType = NUMBER;
                                    currentOperator = "";
                                    operator = null;
                                    currentParam = (currentParam + currentChar);
                                    break;
                                case ".":
                                    currentParam = (currentParam + ".");
                                    break;
                                default:
                                    if ((((currentChar == "-")) || ((currentChar == "+"))))
                                    {
                                        if (!(currentParam.length))
                                        {
                                            currentParam = (currentParam + currentChar);
                                            break;
                                        };
                                    };
                                    _local_15 = true;
                                    _local_16 = false;
                                    currentOperator = (currentOperator + currentChar);
                                    switch (currentOperator)
                                    {
                                        case "-":
                                            operator = this.minus;
                                            break;
                                        case "+":
                                            operator = this.plus;
                                            break;
                                        case "*":
                                            operator = this.multiply;
                                            break;
                                        case "/":
                                            operator = this.divide;
                                            break;
                                        case ">":
                                            if (expr.charAt((i + 1)) != "=")
                                            {
                                                operator = this.sup;
                                            }
                                            else
                                            {
                                                _local_16 = true;
                                                _local_15 = false;
                                            };
                                            break;
                                        case ">=":
                                            operator = this.supOrEquals;
                                            break;
                                        case "<":
                                            if (expr.charAt((i + 1)) != "=")
                                            {
                                                operator = this.inf;
                                            }
                                            else
                                            {
                                                _local_16 = true;
                                                _local_15 = false;
                                            };
                                            break;
                                        case "<=":
                                            operator = this.infOrEquals;
                                            break;
                                        case "&&":
                                            operator = this.and;
                                            break;
                                        case "||":
                                            operator = this.or;
                                            break;
                                        case "==":
                                            operator = this.equals;
                                            break;
                                        case "!=":
                                            operator = this.diff;
                                            break;
                                        case "?":
                                            operator = this.ternary;
                                            break;
                                        case ":":
                                            operator = this.opElse;
                                            break;
                                        case "|":
                                        case "=":
                                        case "&":
                                        case "!":
                                            _local_16 = true;
                                        default:
                                            _local_15 = false;
                                    };
                                    if (_local_15)
                                    {
                                        if (currentParam.length)
                                        {
                                            if (currentType == STRING)
                                            {
                                                op.push(currentParam);
                                            }
                                            else
                                            {
                                                op.push(parseFloat(currentParam));
                                            };
                                            op.push(operator);
                                        }
                                        else
                                        {
                                            _log.warn(this.showPosInExpr(i, expr));
                                            _log.warn(((("Expecting Number at char " + i) + ", but found operator ") + currentChar));
                                        };
                                        currentParam = "";
                                    }
                                    else
                                    {
                                        if (!(_local_16))
                                        {
                                            _log.warn(this.showPosInExpr(i, expr));
                                            _log.warn(("Bad character at " + i));
                                        };
                                    };
                            };
                        }
                        else
                        {
                            currentOperator = "";
                            operator = null;
                            currentParam = (currentParam + currentChar);
                            protect = false;
                        };
                    };
                };
                i++;
            };
            if (currentParam.length)
            {
                if (currentType == STRING)
                {
                    op.push(currentParam);
                }
                else
                {
                    op.push(parseFloat(currentParam));
                };
            };
            var operatorPriority:Array = [this.divide, this.multiply, this.minus, this.plus, this.sup, this.inf, this.supOrEquals, this.infOrEquals, this.equals, this.diff, this.and, this.or, this.ternary];
            var j:uint;
            while (j < operatorPriority.length)
            {
                partialOp = new Array();
                k = 0;
                while (k < op.length)
                {
                    if ((((op[k] is Function)) && ((op[k] == operatorPriority[j]))))
                    {
                        lastOp = partialOp[(partialOp.length - 1)];
                        if ((((lastOp is Number)) || ((((((((((op[k] == this.plus)) || ((op[k] == this.ternary)))) || ((op[k] == this.equals)))) || ((op[k] == this.diff)))) && ((lastOp is String))))))
                        {
                            if ((((op[(k + 1)] is Number)) || ((((((((((op[k] == this.plus)) || ((op[k] == this.ternary)))) || ((op[k] == this.equals)))) || ((op[k] == this.diff)))) && ((op[(k + 1)] is String))))))
                            {
                                if (op[k] === this.ternary)
                                {
                                    if (op[(k + 2)] == this.opElse)
                                    {
                                        partialOp[(partialOp.length - 1)] = this.ternary(lastOp, op[(k + 1)], op[(k + 3)]);
                                        k = (k + 2);
                                    }
                                    else
                                    {
                                        _log.warn("operator ':' not found");
                                    };
                                }
                                else
                                {
                                    partialOp[(partialOp.length - 1)] = op[k](lastOp, op[(k + 1)]);
                                };
                            }
                            else
                            {
                                _log.warn((("Expect Number, but find [" + op[(k + 1)]) + "]"));
                            };
                            k++;
                        }
                        else
                        {
                            lastOp = op[(k - 1)];
                            if ((((lastOp is Number)) || ((((((((((op[k] == this.plus)) || ((op[k] == this.ternary)))) || ((op[k] == this.equals)))) || ((op[k] == this.diff)))) && ((lastOp is String))))))
                            {
                                if ((((op[(k + 1)] is Number)) || ((((((((((op[k] == this.plus)) || ((op[k] == this.ternary)))) || ((op[k] == this.equals)))) || ((op[k] == this.diff)))) && ((op[(k + 1)] is String))))))
                                {
                                    if (op[k] === this.ternary)
                                    {
                                        if (op[(k + 2)] == this.opElse)
                                        {
                                            partialOp[(partialOp.length - 1)] = this.ternary(lastOp, op[(k + 1)], op[(k + 3)]);
                                        }
                                        else
                                        {
                                            _log.warn("operator ':' not found");
                                        };
                                    }
                                    else
                                    {
                                        partialOp.push(op[k](lastOp, op[(k + 1)]));
                                    };
                                }
                                else
                                {
                                    _log.warn((("Expect Number,  but find [" + op[(k + 1)]) + "]"));
                                };
                                k++;
                            };
                        };
                    }
                    else
                    {
                        partialOp.push(op[k]);
                    };
                    k++;
                };
                op = partialOp;
                j++;
            };
            return (op[0]);
        }

        private function complexEval(expr:String)
        {
            var start:int;
            var res:*;
            var i:uint;
            expr = this.trim(expr);
            var modif:Boolean = true;
            var parenthCount:int;
            while (modif)
            {
                modif = false;
                i = 0;
                while (i < expr.length)
                {
                    if (expr.charAt(i) == "(")
                    {
                        if (!(parenthCount))
                        {
                            start = i;
                        };
                        parenthCount++;
                    };
                    if (expr.charAt(i) == ")")
                    {
                        parenthCount--;
                        if (!(parenthCount))
                        {
                            res = this.complexEval(expr.substr((start + 1), ((i - start) - 1)));
                            expr = ((expr.substr(0, start) + (((res is Number)) ? res : (("'" + res) + "'"))) + expr.substr((i + 1)));
                            modif = true;
                            break;
                        };
                    };
                    i++;
                };
            };
            if (parenthCount)
            {
                _log.warn(("Missing right parenthesis in " + expr));
            };
            return (this.simpleEval(expr));
        }

        private function plus(a:*, b:*)
        {
            return ((a + b));
        }

        private function minus(a:Number, b:Number):Number
        {
            return ((a - b));
        }

        private function multiply(a:Number, b:Number):Number
        {
            return ((a * b));
        }

        private function divide(a:Number, b:Number):Number
        {
            return ((a / b));
        }

        private function sup(a:Number, b:Number):Number
        {
            return ((((a > b)) ? 1 : 0));
        }

        private function supOrEquals(a:Number, b:Number):Number
        {
            return ((((a >= b)) ? 1 : 0));
        }

        private function inf(a:Number, b:Number):Number
        {
            return ((((a < b)) ? 1 : 0));
        }

        private function infOrEquals(a:Number, b:Number):Number
        {
            return ((((a <= b)) ? 1 : 0));
        }

        private function and(a:Number, b:Number):Number
        {
            return (((((a) && (b))) ? 1 : 0));
        }

        private function or(a:Number, b:Number):Number
        {
            return (((((a) || (b))) ? 1 : 0));
        }

        private function equals(a:*, b:*):Number
        {
            return ((((a)==b) ? 1 : 0));
        }

        private function diff(a:*, b:*):Number
        {
            return ((((a)!=b) ? 1 : 0));
        }

        private function ternary(cond:Number, a:*, b:*)
        {
            return (((cond) ? a : b));
        }

        private function opElse():void
        {
        }

        private function showPosInExpr(pos:uint, expr:String):String
        {
            var res:String = (expr + "\n");
            var i:uint;
            while (i < pos)
            {
                res = (res + " ");
                i++;
            };
            return ((res + "^"));
        }

        private function trim(str:String):String
        {
            var curChar:String;
            var res:String = "";
            var protect:Boolean;
            var inQuote:Boolean;
            var i:uint;
            while (i < str.length)
            {
                curChar = str.charAt(i);
                if ((((curChar == "'")) && (!(protect))))
                {
                    inQuote = !(inQuote);
                };
                if (curChar == "\\")
                {
                    protect = true;
                }
                else
                {
                    protect = false;
                };
                if (((!((curChar == " "))) || (inQuote)))
                {
                    res = (res + curChar);
                };
                i++;
            };
            return (res);
        }


    }
}//package com.ankamagames.jerakine.eval

