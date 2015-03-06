using System;

namespace CannonAttack
{
    public sealed class Cannon
    {
        private readonly string CANNONID = "Human";
        private string CannonId;
        public static readonly int MAXANGLE = 90;
        public static readonly int MINANGLE = 1;
        private readonly int MAXVELOCITY = 300000000;
        private readonly int MAXDISTANCEOFTARGET = 20000;
        private readonly double GRAVITY = 9.8;
        private readonly int BURSTRADIUS = 50;
        private int distanceOfTarget;
        private int shots;

        public int DistanceOfTarget
        {
            get { return distanceOfTarget; }
            set { distanceOfTarget = value; }
        }
        public string Id
        {
            get
            {
                return (string.IsNullOrWhiteSpace(CannonId)) ? CANNONID : CannonId;
            }
            set { CannonId = value; }
        }
        public int Shots
        {
            get
            {
                return shots;
            }
        }

        private static Cannon cannonSingletonInstance;
        private static readonly object padlock = new object();
        private Cannon()
        {
            //by default we setup a random target
            Random r = new Random();
            SetTarget(r.Next(MAXDISTANCEOFTARGET));
        }

        public void Reset()
        {
            shots = 0;
        }

        public static Cannon GetInstance()
        {
            lock(padlock)
            return cannonSingletonInstance ?? (cannonSingletonInstance = new Cannon());
        }

        public Tuple<bool, string> Shoot(int angle, int velocity)
        {
            if (velocity > MAXVELOCITY)
            {
                return Tuple.Create(false,
                    "Velocity of the cannon cannot travel faster than the speed of light");
            }

            if (angle > 90 || angle < 0) return Tuple.Create(false, "Angle Incorrect");

            shots++;

            string message;
            bool hit;
            int distanceOfShot = CalculateDistanceOfCannonShot(angle, velocity);
            if(distanceOfShot.WithinRange(distanceOfTarget, BURSTRADIUS))
            {
                message = String.Format("Hit - {0} Shot(s)", shots);
                hit = true;
            }
            else
            {
                message = String.Format("Missed cannonball landed at {0} meters", distanceOfShot);
                hit = false;
            }
            return Tuple.Create(hit, message);
        }

        public int CalculateDistanceOfCannonShot(int angle, int velocity)
        {
            int time = 0;
            double height = 0;
            double distance = 0;
            double angleInRadians = (3.1415926536 / 180) * angle;
            while(height >= 0)
            {
                time++;
                distance = velocity * Math.Cos(angleInRadians) * time;
                height = (velocity * Math.Sin(angleInRadians) * time) - (GRAVITY * Math.Pow(time, 2)) / 2;
            }
            return (int) distance;
        }

        public void SetTarget(int distanceOfTarge)
        {
            if(!distanceOfTarget.Between(0, MAXDISTANCEOFTARGET))
                throw new ApplicationException(String.Format("Target distance must be between 1 and {0} meters",
                    MAXDISTANCEOFTARGET));

            distanceOfTarget = distanceOfTarge;
        }
    }
}
