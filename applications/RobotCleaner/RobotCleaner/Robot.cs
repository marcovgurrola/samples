using System;
using System.Collections.Generic;
using System.Threading;

namespace RobotCleaner
{
    public sealed class Robot
    {
        #region Members and Constats
        private const char E_COOR = 'E';
        private const char W_COOR = 'W';
        private const char S_COOR = 'S';
        private const char N_COOR = 'N';
        private const char VERTEX = 'V';
        private const int INVALIDVALUE = 100001;
        private readonly int MINCOMMS = 0;
        private readonly int MAXCOMMS = 10000;
        private readonly int MINCOOR = -100000;
        private readonly int MAXCOOR = 100000;
        private readonly int MINSTEPS = 1;
        private readonly int MAXSTEPS = 99999;

        static readonly object objLock = new object();
        private static Robot robotInstance;
        public static List<char> Directions;
        private Dictionary<string, bool> dicCleaned;
        #endregion

        #region Properties
        public static int Cleaned
        {
            get;
            set;
        }

        public int X
        {
            get;
            set;
        }

        public int Y
        {
            get;
            set;
        }

        public int Commands
        {
            get;
            set;
            /*
            get { return _commands; }
            set
            {
                if (value < MINCOMMS) _commands = MINCOMMS;
                else if (value > MAXCOMMS) _commands = MAXCOMMS;
                else _commands = value;
            }
            */
        }

        public int Steps
        {
            get;
            set;
            /*
            get
            {
                return (_steps >= MINSTEPS && _steps <= MAXSTEPS) ? _steps : INVALIDVALUE;
            }
            set
            { _steps = value; }
            */
        }
        #endregion

        #region Constructors
        private Robot()
        {
            Reset();
            Directions = new List<char>() { E_COOR, W_COOR, S_COOR, N_COOR };
        }
        #endregion

        #region Methods
        private void Reset()
        {
            Cleaned = 0;
            dicCleaned = new Dictionary<string, bool>();
        }

        public static Robot GetInstance()
        {
            Monitor.Enter(objLock);
            try
            {
                if (robotInstance == null)
                    robotInstance = new Robot();

                return robotInstance;
            }
            finally
            { Monitor.Exit(objLock); }
        }

        public Tuple<bool, string> Setup(int commands, int initialX, int initialY)
        {
            Reset();

            //Number of commands must be between 0 and 10000
            if (commands > MAXCOMMS || commands < MINCOMMS)
                return Tuple.Create(false, "Invalid number of commands");

            if (initialX < MINCOOR || initialX > MAXCOOR)
                return Tuple.Create(false, "Invalid X coordinate");

            if (initialY < MINCOOR || initialY > MAXCOOR)
                return Tuple.Create(false, "Invalid Y coordinate");

            Commands = commands;
            X = initialX;
            Y = initialY;

            if((X == MINCOOR || X == MAXCOOR) && (Y == MINCOOR || Y == MAXCOOR))
                return Tuple.Create(true, "Setup OK, Origin at Vertex! Perform Clean please");
            
            return Tuple.Create(true, "Setup OK");
        }

        public Tuple<bool, string> ExecStep(char direction, int steps)
        {
            if(!Directions.Contains(direction))
                return Tuple.Create(false, "Invalid Direction");

            if (steps < MINSTEPS || steps > MAXSTEPS)
                return Tuple.Create(false, "Invalid Step number");

            bool bCleaned = Clean(direction, steps);

            if(bCleaned)
                return Tuple.Create(true, "Efective Step(s).");
            else
                return Tuple.Create(false, "Ineffective Step(s).");
        }

        public bool Clean(char direction, int steps)
        {
            switch (direction)
            {
                case E_COOR:
                    X += steps;
                    break;
                case W_COOR:
                    X -= steps;
                    break;
                case S_COOR:
                    Y -= steps;
                    break;
                case N_COOR:
                    Y += steps;
                    break;
                case VERTEX:
                    break;
                default:
                    return false;
            }

            string strPoint = string.Format("{0},{1}", X, Y);
            if (!dicCleaned.ContainsKey(strPoint))
            {
                dicCleaned.Add(strPoint, true);
                Cleaned++;
            }
            
            return true;
        }
        #endregion
    }
}