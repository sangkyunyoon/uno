using System;
using System.Linq;
using System.IO;
using System.Reflection;
using Uno.Extensions;
using Uno.Extensions.Specialized;
using Uno.Roslyn;
using System.Diagnostics;
using Microsoft.CodeAnalysis;

#if NETFRAMEWORK
using Uno.SourceGeneration;
#endif

namespace Uno.UI.SourceGenerators
{
	internal class DependenciesInitializer
	{
		internal static void Init(GeneratorExecutionContext context)
		{
#if NETSTANDARD2_0
			// Kept until dependencies can be added automatically and this is not needed anymore
			//
			var assemblyName = typeof(DependenciesInitializer).Assembly.GetName().Name;
			var baseAnalyzer = context.GetMSBuildItems("Analyzer")
				.Where(f => f.Identity.EndsWith(assemblyName + ".dll"))
				.FirstOrDefault();

			if (baseAnalyzer != null)
			{
				var basePath = Path.GetDirectoryName(baseAnalyzer.Identity);

				foreach (var file in Directory.EnumerateFiles(basePath, "*.dll"))
				{
					Assembly.LoadFrom(file);
				}
			}
#endif
		}
	}
}
