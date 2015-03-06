namespace CannonAttack
{
    public static class ExtensionMethods
    {
        public static bool Between(this int source, int min, int max)
        {
            return (source >= min && source <= max);
        }

        public static bool WithinRange(this int source, int target, int offset)
        {
            return (target.Between(source - offset, source + offset));
        }
    }
}
