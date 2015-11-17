using System;
using System.Text;

namespace RobotCleaner
{
    class RobotCleaner
    {
        static void Main(string[] args)
        {
            ShowMessage("********************I am Robot Clean!********************\n");

            StringBuilder sb = new StringBuilder(
            "***********************INSTRUCTIONS**********************\n" +
            "1st Input Line: Number of Commands to be executed........\n" +
            "Format:         Single Integer value.....................\n" +
            "Range:          0 <= n <= 10000..........................\n" +
            "Example:		 20.......................................\n\n" +
            "2nd Input Line: Initial coordinates (X Y)................\n" +
            "Format:         Integer values separated by a white space\n" +
            "Range:          -100000 <= n <= 100000...................\n" +
            "Example:        10 20....................................\n" +
            "Note:           Vertexes will be automatically cleaned!..\n\n" +
            "3rd and subsequent Input Lines:..........................\n" +
            "................Direction and steps......................\n" +
            "Format:         Single Upper Case Char and Integer Value \n" +
            "................separated by a white space...............\n" +
            "Range:          (E, W, S or N), 0 < n < 100000 respective\n" +
            "Example:        W 100....................................\n\n");
            ShowMessage(sb.ToString());

            AutoClean();
        }

        static void AutoClean()
        {
            int numCommands = 0;
            int steps = 0;
            int x = 0;
            int y = 0;
            string coordinates = string.Empty;
            Robot robot = Robot.GetInstance();

            if (!Int32.TryParse(GetInput(), out numCommands))
                Exit("");

            string[] inputArray = GetInput().Split(' ');
            if (inputArray == null || inputArray.Length != 2)
                Exit("");

            if (!Int32.TryParse(inputArray[0], out x))
                Exit("");

            if (!Int32.TryParse(inputArray[1], out y))
                Exit("");

            //Robot Initialization
            Tuple<bool, string> result = robot.Setup(numCommands, x, y);

            if (!result.Item1)
                Exit("");

            //Vertex has always to be cleaned
            if (result.Item2.Contains("Vertex"))
                robot.Clean('V', 0);

            //Directions and Steps
            for (int i = 1; i <= numCommands; i++)
            {
                inputArray = GetInput().Split(' ');
                if (inputArray == null || inputArray.Length != 2)
                    Exit("");

                char[] direction = inputArray[0].ToCharArray();
                if (!Robot.Directions.Contains(direction[0]))
                    Exit("");

                if (!Int32.TryParse(inputArray[1], out steps))
                    Exit("");

                robot.ExecStep(direction[0], steps);
            }

            ShowMessage(string.Format("=> Cleaned: {0}\n", Robot.Cleaned));
            Exit("");
        }

        static void ShowMessage(string message)
        {
            Console.Out.WriteLine(message);
        }

        static string GetInput()
        {
            return Console.In.ReadLine();
        }

        static void Exit(string message)
        {
            ShowMessage(message);
            ShowMessage("Press r to Start Again or x to Exit\n");
            ConsoleKeyInfo cki = new ConsoleKeyInfo();

            while (cki.KeyChar != 'r' && cki.KeyChar != 'x')
                cki = Console.ReadKey();

            if(cki.KeyChar == 'x')
                Environment.Exit(0);

            ShowMessage("\nRobot will perfom a new cleaning process!\n");
            AutoClean();
        }
    }
}
